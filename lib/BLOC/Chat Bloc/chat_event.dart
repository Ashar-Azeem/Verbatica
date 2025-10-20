part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialChats extends ChatEvent {
  //Fetch first 10 chats
  final int userId;
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

class AddNewChat extends ChatEvent {
  final Chat chat;

  const AddNewChat({required this.chat});
}

class HandleIncomingMessages extends ChatEvent {
  final Map<String, dynamic> message;

  const HandleIncomingMessages({required this.message});
}

class UpdateOnlineUsers extends ChatEvent {
  final Set<String> onlineUsers;

  const UpdateOnlineUsers({required this.onlineUsers});
}
