import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:verbatica/DummyData/chats.dart';
import 'package:verbatica/model/Chat.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState()) {
    on<FetchInitialChats>(fetchInitialChats);
    on<DeleteChat>(deleteChat);
    on<SeenStatus>(seenStatus);
  }

  fetchInitialChats(FetchInitialChats event, Emitter<ChatState> emit) {
    //Async operation to retreive first latest 10 chats

    //Logic for checking the any unseen chat so we could display the dot on the message icon in the home screen

    if (state.chats.isEmpty) {
      List<Chat> fetchedChats = dummyChats;
      bool isAnyUnReaad = false;
      for (Chat chat in fetchedChats) {
        bool seenStatus = chat.lastMessageSeenBy[event.userId]!;
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
  }

  deleteChat(DeleteChat event, Emitter<ChatState> emit) {
    List<Chat> chats = List.from(state.chats);
    chats.removeAt(event.index);
    emit(state.copyWith(chats: chats));
  }

  seenStatus(SeenStatus event, Emitter<ChatState> emit) {
    List<Chat> chats = List.from(state.chats);
    for (Chat chat in chats) {
      if (chat.chatId == event.chatId) {
        Map<String, bool> seenBy = Map.from(chat.lastMessageSeenBy);
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
}
