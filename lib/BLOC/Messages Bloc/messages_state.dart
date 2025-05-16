part of 'messages_bloc.dart';

class MessagesState extends Equatable {
  final Message? lastMessage;
  final ChatController? controller;
  final bool isLast;
  final ChatViewState state;
  final bool replyingToMessageBar;
  const MessagesState({
    this.controller,
    this.replyingToMessageBar = false,
    this.lastMessage,
    this.isLast = true,
    this.state = ChatViewState.loading,
  });

  MessagesState copyWith({
    Message? lastMessage,
    bool? isLast,
    ChatViewState? state,
    bool? replyingToMessageBar,
    ChatController? controller,
  }) {
    return MessagesState(
      lastMessage: lastMessage ?? this.lastMessage,
      isLast: isLast ?? this.isLast,
      state: state ?? this.state,
      replyingToMessageBar: replyingToMessageBar ?? this.replyingToMessageBar,
      controller: controller ?? this.controller,
    );
  }

  @override
  List<Object?> get props => [
    lastMessage,
    isLast,
    state,
    replyingToMessageBar,
    controller,
  ];
}
