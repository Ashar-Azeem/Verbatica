part of 'messages_bloc.dart';

class MessagesState extends Equatable {
  final List<Message> messages;
  final ChatController? controller;
  final bool isLast;
  final ChatViewState state;
  final bool replyingToMessageBar;
  const MessagesState({
    this.controller,
    this.replyingToMessageBar = false,
    this.messages = const [],
    this.isLast = true,
    this.state = ChatViewState.loading,
  });

  MessagesState copyWith({
    List<Message>? messages,
    bool? isLast,
    ChatViewState? state,
    bool? replyingToMessageBar,
    ChatController? controller,
  }) {
    return MessagesState(
      messages: messages ?? this.messages,
      isLast: isLast ?? this.isLast,
      state: state ?? this.state,
      replyingToMessageBar: replyingToMessageBar ?? this.replyingToMessageBar,
      controller: controller ?? this.controller,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    isLast,
    state,
    replyingToMessageBar,
    controller,
  ];
}
