import 'package:bloc/bloc.dart';
import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Services/endToEndEncryption.dart';
import 'package:verbatica/Services/socket.dart';
import 'package:verbatica/model/Chat.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final SocketService _socketService = SocketService();
  late final Function(dynamic) _onMessageCallback;
  late final Function(dynamic) _onSeenAckCallBack;
  late final Function(dynamic) _onUpdateAckCallBack;

  E2EEChat encryptionService = E2EEChat();

  final BuildContext context;

  String? chatSecretKey;
  Chat currentChat;
  final limit = 15;
  final int userId;
  MessagesBloc({
    required this.currentChat,
    required this.userId,
    required this.context,
    required ScrollController scrollController,
  }) : super(MessagesState()) {
    _onMessageCallback = (data) async {
      if (!isClosed && data['chatId'] == currentChat.chatId) {
        Message message = Message.fromJson(data);
        //Decrypting the message
        String plainText = await encryptionService.decrypt(
          message.message,
          chatSecretKey!,
        );
        message = message.copyWith(
          createdAt: message.createdAt.toLocal(),
          message: plainText,
        );
        add(AddMessage(message: message));
      }
    };
    _onSeenAckCallBack = (data) {
      if (!isClosed && data['chatId'] == currentChat.chatId) {
        add(UpdateSeenStatus());
      }
    };
    _onUpdateAckCallBack = (data) {
      if (!isClosed && data['chatId'] == currentChat.chatId) {
        Message message = Message.fromJson(data);

        add(UpdateMessage(message: message));
      }
    };

    //Listner
    _socketService.onNewMessage(_onMessageCallback);
    _socketService.onSeenAck(_onSeenAckCallBack);
    _socketService.onUpdateAck(_onUpdateAckCallBack);

    on<FetchInitialMessages>(fetchInitialMessages);
    on<FetchMoreMessages>(fetchMoreMessages);
    on<AddReplyBar>(addReplyBar);
    on<RemoveReplyBar>(removeReplyBar);
    on<SendMessage>(sendMessage);
    on<AddReaction>(addReaction);
    on<AddMessage>(addMessage);
    on<UpdateMessage>(updateMessage);
    on<UpdateSeenStatus>(seenStatus);
    add(
      FetchInitialMessages(
        chat: currentChat,
        userId: userId,
        scrollController: scrollController,
      ),
    );
  }

  updateMessage(UpdateMessage event, Emitter<MessagesState> emit) {
    List<Message> messages = state.controller!.initialMessageList;
    int index = messages.indexWhere((m) => m.id == event.message.id);
    if (index != -1) {
      state.controller!.setReaction(
        emoji: event.message.reaction.reactions.first,
        messageId: event.message.id,
        userId: event.message.reaction.reactedUserIds.first,
      );
    }
  }

  addMessage(AddMessage event, Emitter<MessagesState> emit) async {
    //My Messages
    if (event.message.sentBy == userId.toString()) {
      List<Message> messages = state.controller!.initialMessageList;
      int index = messages.indexWhere((m) => m.id == event.message.id);
      if (index != -1) {
        state.controller!.initialMessageList[index].setStatus =
            MessageStatus.delivered;
      }
    }
    //Other User messages
    else {
      ApiService().seenAck(
        currentChat.chatId,
        userId.toString(),
        event.message.sentBy,
      );

      state.controller!.addMessage(event.message);
    }
  }

  seenStatus(UpdateSeenStatus event, Emitter<MessagesState> emit) {
    List<Message> messages = state.controller!.initialMessageList;
    int index = -1;
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].sentBy == userId.toString()) {
        index = i;
      }
    }
    if (index != -1) {
      state.controller!.initialMessageList[index].setStatus =
          MessageStatus.read;
    }
  }

  fetchInitialMessages(
    FetchInitialMessages event,
    Emitter<MessagesState> emit,
  ) async {
    OtherUserInfo otherUser = event.chat.getOtherUserInfo(userId);
    //Deriving the secret key:
    String myPrivateKey = await TokenOperations().loadPrivateKey();
    chatSecretKey = await encryptionService.deriveSharedSecret(
      myPrivateKey,
      event.chat.getOtherUserInfo(event.userId).publicKey,
    );
    List<Message> messages =
        event.chat.chatId.isEmpty
            ? []
            : await ApiService().fetchMessages(
              event.chat.chatId,
              DateTime.now(),
            );

    //Changing the default status and decrypting the message
    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];

      // Change the default status
      message.setStatus = MessageStatus.delivered;

      // Decrypt the message
      final plainText = await encryptionService.decrypt(
        message.message,
        chatSecretKey!,
      );

      // Update the message in the list
      messages[i] = message.copyWith(message: plainText);
    }

    //Update the seen status for the other user
    if (messages.isNotEmpty) {
      if (messages[messages.length - 1].sentBy != userId.toString()) {
        ApiService().seenAck(
          currentChat.chatId,
          userId.toString(),
          messages[messages.length - 1].sentBy,
        );
      }
    }
    //Update the UI if other user has seen the messages
    if (currentChat.lastMessageSeenBy[otherUser.userId] == true) {
      if (messages[messages.length - 1].sentBy == userId.toString()) {
        messages[messages.length - 1].setStatus = MessageStatus.read;
      }
    }
    //initializing chat controller
    ChatController chatController = ChatController(
      scrollController: event.scrollController,
      initialMessageList: messages,
      currentUser: ChatUser(
        id: userId.toString(),
        imageType: ImageType.asset,
        name: event.chat.userNames[userId]!,
        profilePhoto:
            'assets/Avatars/avatar${event.chat.userProfiles[userId]}.jpg',
      ),
      otherUsers: [
        ChatUser(
          imageType: ImageType.asset,
          id:
              event.chat.participantIds
                  .firstWhere((id) => id != userId)
                  .toString(),
          name: otherUser.userName,
          profilePhoto: 'assets/Avatars/avatar${otherUser.userProfile}.jpg',
        ),
      ],
    );

    emit(
      state.copyWith(
        lastMessage: messages.isEmpty ? null : messages[0],
        state: ChatViewState.hasMessages,
        isLast: messages.length < limit ? true : false,
        controller: chatController,
      ),
    );
  }

  addReplyBar(AddReplyBar event, Emitter<MessagesState> emit) {
    emit(state.copyWith(replyingToMessageBar: true));
  }

  fetchMoreMessages(
    FetchMoreMessages event,
    Emitter<MessagesState> emit,
  ) async {
    if (!state.isLast) {
      List<Message> messages = await ApiService().fetchMessages(
        event.chatId,
        state.lastMessage!.createdAt,
      );

      for (int i = 0; i < messages.length; i++) {
        final message = messages[i];

        // Change the default status
        message.setStatus = MessageStatus.delivered;

        // Decrypt the message
        final plainText = await encryptionService.decrypt(
          message.message,
          chatSecretKey!,
        );

        // Update the message in the list
        messages[i] = message.copyWith(message: plainText);
      }

      state.controller!.loadMoreData(messages);

      emit(
        state.copyWith(
          lastMessage: messages.isEmpty ? null : messages[0],
          state: ChatViewState.hasMessages,
          isLast: messages.length < limit ? true : false,
        ),
      );
    }
  }

  removeReplyBar(RemoveReplyBar event, Emitter<MessagesState> emit) {
    emit(state.copyWith(replyingToMessageBar: false));
  }

  sendMessage(SendMessage event, Emitter<MessagesState> emit) async {
    String cypherText = await encryptionService.encrypt(
      event.message.message,
      chatSecretKey!,
    );
    String messageId = Uuid().v4();
    Message message = event.message.copyWith(
      status: MessageStatus.pending,
      id: messageId,
    );
    //First add the original text to the UI
    state.controller!.addMessage(message);
    //Then prepare the cypher text for the backend
    message = message.copyWith(message: cypherText);

    ApiService().sendingMessage(
      message,
      event.chat.chatId,
      event.otherUserId.toString(),
      messageId,
      message.createdAt,
    );
    //updating the chat if initially no specific chat exists in the database now it will exist
    if (currentChat.chatId.isEmpty) {
      currentChat = event.chat;
    }
  }

  addReaction(AddReaction event, Emitter<MessagesState> emit) {
    ApiService().updateMessage(
      event.message.id,
      {'emoji': event.emoji, 'reactedUser': event.userId.toString()},
      currentChat.getOtherUserInfo(event.userId).userId.toString(),
    );
  }

  @override
  Future<void> close() {
    //turn the bloc of this callback listner
    _socketService.offNewMessage(_onMessageCallback);
    _socketService.offSeenAck(_onSeenAckCallBack);
    _socketService.offUpdateAck(_onUpdateAckCallBack);
    return super.close();
  }
}
