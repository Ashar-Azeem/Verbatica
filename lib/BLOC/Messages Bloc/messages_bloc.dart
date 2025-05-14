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
    required String userId,
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

    Future.delayed(Duration(seconds: 2));
    List<Message> allMessages = messagesBetween1And2;
    List<Message> subMessages = allMessages.sublist(allMessages.length - 12);
    //initializing chat controller
    String userId = event.userId;
    OtherUserInfo otherUser = event.chat.getOtherUserInfo(userId);
    ChatController chatController = ChatController(
      scrollController: event.scrollController,
      initialMessageList: subMessages,
      currentUser: ChatUser(
        id: userId,
        imageType: ImageType.asset,
        name: event.chat.userNames[userId]!,
        profilePhoto:
            'assets/Avatars/avatar${event.chat.userProfiles[userId]}.jpg',
      ),
      otherUsers: [
        ChatUser(
          imageType: ImageType.asset,
          id: event.chat.participantIds.firstWhere((id) => id != userId),
          name: otherUser.userName,
          profilePhoto: 'assets/Avatars/avatar${otherUser.userProfile}.jpg',
        ),
      ],
    );

    emit(
      state.copyWith(
        state: ChatViewState.hasMessages,
        messages: subMessages,
        isLast: false,
        controller: chatController,
      ),
    );
  }

  addReplyBar(AddReplyBar event, Emitter<MessagesState> emit) {
    emit(state.copyWith(replyingToMessageBar: true));
  }

  fetchMoreMessages(FetchMoreMessages event, Emitter<MessagesState> emit) {
    List<Message> allMessages = messagesBetween1And2;
    List<Message> subMessages = [];
    for (Message message in allMessages) {
      if (!state.controller!.initialMessageList.contains(message)) {
        subMessages.add(message);
      }
    }

    //Never ever add redundant messages here or else it would break the whole UI
    state.controller!.loadMoreData(subMessages);
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
      reactedUserIds: [event.userId],
    );

    print(newMessage.reaction.reactions);
  }
}
