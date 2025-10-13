part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialChats extends ChatEvent {
  //Fetch first 10 chats
  final String userId;
  const FetchInitialChats({required this.userId});
}

class DeleteChat extends ChatEvent {
  final int index;

  const DeleteChat({required this.index});
}

class SeenStatus extends ChatEvent {
  final int userId;
  final String chatId;

  const SeenStatus({required this.userId, required this.chatId});
}
