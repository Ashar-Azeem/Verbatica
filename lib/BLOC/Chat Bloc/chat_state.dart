part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<Chat> chats;
  final bool initialLoading;
  final bool bottomLoading;
  final bool isAnyUnread;
  const ChatState({
    this.chats = const [],
    this.initialLoading = true,
    this.bottomLoading = true,
    this.isAnyUnread = false,
  });

  ChatState copyWith({
    List<Chat>? chats,
    bool? initialLoading,
    bool? bottomLoading,
    bool? isAnyUnread,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      initialLoading: initialLoading ?? this.initialLoading,
      bottomLoading: bottomLoading ?? this.bottomLoading,
      isAnyUnread: isAnyUnread ?? this.isAnyUnread,
    );
  }

  @override
  List<Object> get props => [chats, initialLoading, bottomLoading, isAnyUnread];
}
