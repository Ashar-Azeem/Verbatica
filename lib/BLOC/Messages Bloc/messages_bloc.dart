import 'package:bloc/bloc.dart';
import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:verbatica/DummyData/Messages.dart';
import 'package:verbatica/model/Chat.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc({
    required Chat chat,
    required int userId,
    required ScrollController scrollController,
  }) : super(MessagesState()) {
    on<FetchInitialMessages>(fetchInitialMessages);
    on<FetchMoreMessages>(fetchMoreMessages);
    on<AddReplyBar>(addReplyBar);
    on<RemoveReplyBar>(removeReplyBar);
    on<SendMessage>(sendMessage);
    on<AddReaction>(addReaction);

    add(
      FetchInitialMessages(
        chat: chat,
        userId: userId,
        scrollController: scrollController,
      ),
    );
  }

  fetchInitialMessages(
    FetchInitialMessages event,
    Emitter<MessagesState> emit,
  ) async {
    //webSocket using chatId
    List<Message> allMessages = [];
    Future.delayed(Duration(seconds: 2));
    if (event.chat.chatId == "chat_0") {
      allMessages = messagesBetween1And2;
    } else if (event.chat.chatId == "chat_1") {
      allMessages = messagesBetween1And3;
    }
    List<Message> subMessages =
        allMessages.length > 12
            ? allMessages.sublist(allMessages.length - 12)
            : List.from(allMessages);

    //initializing chat controller
    int userId = event.userId;
    OtherUserInfo otherUser = event.chat.getOtherUserInfo(userId);
    ChatController chatController = ChatController(
      scrollController: event.scrollController,
      initialMessageList: subMessages,
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

    // Logic to update the seen status when last message of the other user appears
    Message? lastMessage;
    for (int i = subMessages.length - 1; i >= 0; i--) {
      if (subMessages[i].id != event.userId.toString()) {
        lastMessage = subMessages[i];
        //Also add the logic for updating the seen status for the other user using an api
        break;
      }
    }

    emit(
      state.copyWith(
        lastMessage: lastMessage,
        state: ChatViewState.hasMessages,
        isLast: false,
        controller: chatController,
      ),
    );
  }

  addReplyBar(AddReplyBar event, Emitter<MessagesState> emit) {
    emit(state.copyWith(replyingToMessageBar: true));
  }

  fetchMoreMessages(FetchMoreMessages event, Emitter<MessagesState> emit) {
    List<Message> allMessages = [];
    if (event.chatId == "chat_0") {
      allMessages = messagesBetween1And2;
    } else if (event.chatId == "chat_1") {
      allMessages = messagesBetween1And3;
    }
    List<Message> subMessages = [];
    for (Message message in allMessages) {
      if (!state.controller!.initialMessageList.contains(message)) {
        subMessages.add(message);
      }
    }

    // Logic to update the seen status when last message of the other user appears
    Message? lastMessage;
    for (int i = subMessages.length - 1; i >= 0; i--) {
      if (subMessages[i].id != event.userId.toString()) {
        lastMessage = subMessages[i];
        break;
      }
    }

    //Never ever add redundant messages here or else it would break the whole UI
    state.controller!.loadMoreData(subMessages);

    emit(state.copyWith(lastMessage: lastMessage));
  }

  removeReplyBar(RemoveReplyBar event, Emitter<MessagesState> emit) {
    emit(state.copyWith(replyingToMessageBar: false));
  }

  sendMessage(SendMessage event, Emitter<MessagesState> emit) async {
    event.message.setStatus = MessageStatus.delivered;
    state.controller!.addMessage(event.message);
    //Simulating the sending message
  }

  addReaction(AddReaction event, Emitter<MessagesState> emit) {
    Message newMessage = event.message;
    newMessage.reaction.copyWith(
      reactions: [event.emoji],
      reactedUserIds: [event.userId.toString()],
    );
  }
}
