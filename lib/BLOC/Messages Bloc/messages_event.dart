part of 'messages_bloc.dart';

sealed class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialMessages extends MessagesEvent {
  final Chat chat;
  final int userId;
  final ScrollController scrollController;

  const FetchInitialMessages({
    required this.chat,
    required this.userId,
    required this.scrollController,
  });
}

class FetchMoreMessages extends MessagesEvent {
  final int userId;
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
  final Chat chat;
  final int otherUserId;
  const SendMessage({
    required this.otherUserId,
    required this.chat,
    required this.message,
  });
}

class AddReaction extends MessagesEvent {
  final Message message;
  final String emoji;
  final int userId;
  const AddReaction({
    required this.message,
    required this.emoji,
    required this.userId,
  });
}

class AddMessage extends MessagesEvent {
  final Message message;

  const AddMessage({required this.message});
}

class UpdateSeenStatus extends MessagesEvent {}

class UpdateMessage extends MessagesEvent {
  final Message message;

  const UpdateMessage({required this.message});
}
