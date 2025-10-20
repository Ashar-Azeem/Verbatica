import 'package:bloc/bloc.dart';
import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Services/endToEndEncryption.dart';
import 'package:verbatica/Services/socket.dart';
import 'package:verbatica/model/Chat.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SocketService _socketService = SocketService();
  final BuildContext context;
  String? myPrivateKey;
  E2EEChat encryptionService = E2EEChat();
  late final Function(dynamic) _onOnlineStatus;

  ChatBloc({required this.context}) : super(ChatState()) {
    _onOnlineStatus = (data) {
      if (!isClosed) {
        Set<String> onlineUsers = Set<String>.from(data);
        add(UpdateOnlineUsers(onlineUsers: onlineUsers));
      }
    };

    on<FetchInitialChats>(fetchInitialChats);
    on<DeleteChat>(deleteChat);
    on<SeenStatus>(seenStatus);
    on<AddNewChat>(addNewChat);
    on<UpdateOnlineUsers>(updateOnlineUsers);
    on<HandleIncomingMessages>(handleIncomingMessages);
  }
  void onAppOpened(String userId) {
    _socketService.connect(userId);
    _socketService.onOnlineStatus(_onOnlineStatus);
    _socketService.onNewMessage((data) {
      add(HandleIncomingMessages(message: data));
    });
  }

  void onAppClosed(String userId) {
    _socketService.disconnect(userId);
  }

  handleIncomingMessages(
    HandleIncomingMessages event,
    Emitter<ChatState> emit,
  ) async {
    List<Chat> chats = List.from(state.chats);
    String chatId = event.message['chatId'];
    String userId = context.read<UserBloc>().state.user!.id.toString();
    Message message = Message.fromJson(event.message);

    String chatSecretKey;

    int index = -1;
    for (int i = 0; i < chats.length; i++) {
      if (chats[i].chatId == chatId) {
        index = i;
        break;
      }
    }
    if (message.sentBy == userId) {
      String otherUserPublicKey =
          chats[index].getOtherUserInfo((int.parse(userId))).publicKey;
      chatSecretKey = await encryptionService.deriveSharedSecret(
        myPrivateKey!,
        otherUserPublicKey,
      );

      String plainText = await encryptionService.decrypt(
        message.message,
        chatSecretKey,
      );
      chats[index] = chats[index].copyWith(
        lastMessage: plainText,
        lastUpdated: DateTime.now(),
      );
      emit(state.copyWith(chats: chats));
      return;
    }

    if (index == -1) {
      Chat chat = await ApiService().fetchChat(chatId);
      String otherUserPublicKey =
          chat.getOtherUserInfo((int.parse(userId))).publicKey;
      chatSecretKey = await encryptionService.deriveSharedSecret(
        myPrivateKey!,
        otherUserPublicKey,
      );

      String plainText = await encryptionService.decrypt(
        message.message,
        chatSecretKey,
      );
      chat = chat.copyWith(lastMessage: plainText);
      //decrept the last seen message
      chats.insert(0, chat);
    } else {
      //decrept the last seen message
      Map<int, bool> newLastSeenBy = chats[index].lastMessageSeenBy;
      newLastSeenBy[int.parse(userId)] = false;
      String otherUserPublicKey =
          chats[index].getOtherUserInfo((int.parse(userId))).publicKey;
      chatSecretKey = await encryptionService.deriveSharedSecret(
        myPrivateKey!,
        otherUserPublicKey,
      );

      String plainText = await encryptionService.decrypt(
        message.message,
        chatSecretKey,
      );

      chats[index] = chats[index].copyWith(
        lastMessage: plainText,
        lastMessageSeenBy: newLastSeenBy,
        lastUpdated: DateTime.now(),
      );
    }

    emit(state.copyWith(chats: chats, isAnyUnread: true));
  }

  fetchInitialChats(FetchInitialChats event, Emitter<ChatState> emit) async {
    myPrivateKey = await TokenOperations().loadPrivateKey();
    //Logic for checking the any unseen chat so we could display the dot on the message icon in the home screen
    List<Chat> fetchedChats = await ApiService().fetchUserChats(event.userId);
    //Decrypt all the chats last Message:
    for (int i = 0; i < fetchedChats.length; i++) {
      String otherUserPublicKey =
          fetchedChats[i].getOtherUserInfo((event.userId)).publicKey;
      String chatSecretKey = await encryptionService.deriveSharedSecret(
        myPrivateKey!,
        otherUserPublicKey,
      );

      String plainText = await encryptionService.decrypt(
        fetchedChats[i].lastMessage,
        chatSecretKey,
      );
      fetchedChats[i] = fetchedChats[i].copyWith(lastMessage: plainText);
    }

    bool isAnyUnReaad = false;
    for (Chat chat in fetchedChats) {
      bool seenStatus = !chat.lastMessageSeenBy[event.userId]!;
      if (seenStatus) {
        isAnyUnReaad = true;
        break;
      }
    }
    emit(
      state.copyWith(
        chats: List.from(fetchedChats),
        initialLoading: false,
        isAnyUnread: isAnyUnReaad,
      ),
    );
  }

  deleteChat(DeleteChat event, Emitter<ChatState> emit) {
    List<Chat> chats = List.from(state.chats);
    ApiService().deleteChat(chats[event.index].chatId);
    chats.removeAt(event.index);
    emit(state.copyWith(chats: chats));
  }

  updateOnlineUsers(UpdateOnlineUsers event, Emitter<ChatState> emit) {
    emit(state.copyWith(onlineUsers: event.onlineUsers));
  }

  update(DeleteChat event, Emitter<ChatState> emit) {
    List<Chat> chats = List.from(state.chats);
    ApiService().deleteChat(chats[event.index].chatId);
    chats.removeAt(event.index);
    emit(state.copyWith(chats: chats));
  }

  addNewChat(AddNewChat event, Emitter<ChatState> emit) {
    List<Chat> chats = List.from(state.chats);
    chats.insert(0, event.chat);
    emit(state.copyWith(chats: chats));
  }

  seenStatus(SeenStatus event, Emitter<ChatState> emit) {
    List<Chat> chats = List.from(state.chats);
    for (Chat chat in chats) {
      if (chat.chatId == event.chatId) {
        Map<int, bool> seenBy = Map.from(chat.lastMessageSeenBy);
        seenBy[event.userId] = true;
        chats[chats.indexOf(chat)] = chat.copyWith(lastMessageSeenBy: seenBy);
        break;
      }
    }
    bool isUnRead = false;
    for (Chat chat in chats) {
      if (!chat.lastMessageSeenBy[event.userId]!) {
        isUnRead = true;
      }
    }

    emit(state.copyWith(chats: chats, isAnyUnread: isUnRead));
  }

  @override
  Future<void> close() {
    //turn the bloc of this callback listner
    _socketService.offOnlineStatus(_onOnlineStatus);
    _socketService.disconnect(
      context.read<UserBloc>().state.user!.id.toString(),
    );
    return super.close();
  }
}
