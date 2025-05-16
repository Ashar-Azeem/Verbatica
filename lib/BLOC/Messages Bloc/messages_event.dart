part of 'messages_bloc.dart';

sealed class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialMessages extends MessagesEvent {
  final Chat chat;
  final String userId;
  final ScrollController scrollController;

  const FetchInitialMessages({
    required this.chat,
    required this.userId,
    required this.scrollController,
  });
}

class FetchMoreMessages extends MessagesEvent {
  final String userId;
  final String chatId;
  const FetchMoreMessages({required this.userId, required this.chatId});
}

class AddReplyBar extends MessagesEvent {
  const AddReplyBar();
}

class RemoveReplyBar extends MessagesEvent {
  const RemoveReplyBar();
}

class SendMessage extends MessagesEvent {
  final Message message;
  const SendMessage({required this.message});
}

class AddReaction extends MessagesEvent {
  final Message message;
  final String emoji;
  final String userId;
  const AddReaction({
    required this.message,
    required this.emoji,
    required this.userId,
  });
}
