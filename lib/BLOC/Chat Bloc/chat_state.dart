part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<Chat> chats;
  final bool initialLoading;
  final Set<String> onlineUsers;

  final bool isAnyUnread;
  const ChatState({
    this.onlineUsers = const {},

    this.chats = const [],
    this.initialLoading = true,
    this.isAnyUnread = false,
  });

  ChatState copyWith({
    List<Chat>? chats,
    bool? initialLoading,
    Set<String>? onlineUsers,

    bool? isAnyUnread,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      initialLoading: initialLoading ?? this.initialLoading,
      onlineUsers: onlineUsers ?? this.onlineUsers,

      isAnyUnread: isAnyUnread ?? this.isAnyUnread,
    );
  }

  @override
  List<Object> get props => [chats, initialLoading, isAnyUnread, onlineUsers];
}
