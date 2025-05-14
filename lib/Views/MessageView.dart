// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:chatview/chatview.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Chat%20Bloc/chat_bloc.dart';
import 'package:verbatica/BLOC/Messages%20Bloc/messages_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/Chat.dart';

class MessageView extends StatefulWidget {
  final Chat chat;
  const MessageView({super.key, required this.chat});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  ScrollController scrollController = ScrollController();
  late final Chat chat;
  late final userId;
  late final MessagesBloc messagesBloc;

  @override
  void initState() {
    super.initState();
    chat = widget.chat;
    userId = context.read<UserBloc>().state.user.userId;
    messagesBloc = MessagesBloc(
      chat: chat,
      userId: userId,
      scrollController: scrollController,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    messagesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OtherUserInfo otherUser = chat.getOtherUserInfo(
      context.read<UserBloc>().state.user.userId,
    );
    return BlocProvider.value(
      value: messagesBloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<MessagesBloc, MessagesState>(
            buildWhen:
                (previous, current) =>
                    previous.controller != current.controller ||
                    previous.state != current.state ||
                    previous.replyingToMessageBar !=
                        current.replyingToMessageBar,
            builder: (context, state) {
              return state.controller == null
                  ? Center(
                    child: CupertinoActivityIndicator(color: primaryColor),
                  )
                  : ChatView(
                    reactionPopupConfig: ReactionPopupConfiguration(
                      userReactionCallback: (message, emoji) {
                        context.read<MessagesBloc>().add(
                          AddReaction(
                            message: message,
                            emoji: emoji,
                            userId: userId,
                          ),
                        );
                      },
                    ),
                    replyPopupConfig: ReplyPopupConfiguration(
                      replyPopupBuilder:
                          (message, sentByCurrentUser) => SizedBox.shrink(),
                    ),
                    isLastPage: false,
                    onSendTap: (message, replyMessage, messageType) {
                      if (message.trim().isNotEmpty) {
                        Message newMessages = Message(
                          message: message.trim(),
                          createdAt: DateTime.now(),
                          sentBy: userId,
                          replyMessage: replyMessage,
                          messageType: messageType,
                        );

                        context.read<MessagesBloc>().add(
                          SendMessage(message: newMessages),
                        );
                      }
                    },
                    loadMoreData: () async {
                      context.read<MessagesBloc>().add(FetchMoreMessages());
                    },
                    repliedMessageConfig: RepliedMessageConfiguration(
                      repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
                        highlightColor: Colors.purpleAccent,
                      ),
                      opacity: 1,
                      textStyle: TextStyle(color: Colors.white),
                      replyTitleTextStyle: TextStyle(color: Colors.white),
                      backgroundColor: const Color.fromARGB(255, 144, 178, 230),
                    ),
                    swipeToReplyConfig: SwipeToReplyConfiguration(
                      onLeftSwipe: (message, sentBy) {
                        context.read<MessagesBloc>().add(AddReplyBar());
                      },
                      onRightSwipe: (message, sentBy) {
                        context.read<MessagesBloc>().add(AddReplyBar());
                      },
                    ),
                    replyMessageBuilder: (context, reply) {
                      return state.replyingToMessageBar
                          ? Padding(
                            padding: EdgeInsets.only(bottom: 6.5.h),
                            child: Container(
                              width: 90.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(2.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        chat.userNames[reply.replyTo]!,
                                        style: TextStyle(color: primaryColor),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.read<MessagesBloc>().add(
                                            RemoveReplyBar(),
                                          );
                                        },
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          size: 5.w,
                                          color: Color.fromARGB(
                                            255,
                                            10,
                                            13,
                                            15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.w),
                                  ExpandableText(
                                    reply.message,
                                    expandOnTextTap: true,
                                    collapseOnTextTap: true,
                                    expandText: 'show more',
                                    collapseText: 'show less',
                                    linkEllipsis: false,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 3.8.w,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    linkColor: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          )
                          : SizedBox.shrink();
                    },
                    sendMessageConfig: SendMessageConfiguration(
                      enableCameraImagePicker: false,
                      enableGalleryImagePicker: false,
                      allowRecordingVoice: false,
                      defaultSendButtonColor: primaryColor,
                      replyTitleColor: primaryColor,
                      replyDialogColor: Colors.grey,
                      textFieldConfig: TextFieldConfiguration(
                        borderRadius: BorderRadius.circular(30),
                        padding: EdgeInsets.all(0.4.w),
                        contentPadding: EdgeInsets.only(
                          left: 5.w,
                          top: 1.w,
                          bottom: 1.w,
                        ),
                        textStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    featureActiveConfig: FeatureActiveConfig(
                      enablePagination: true,
                      enableReactionPopup: true,

                      enableOtherUserName: false,
                      enableScrollToBottomButton: true,
                    ),

                    chatBubbleConfig: ChatBubbleConfiguration(
                      onDoubleTap: (message) {},
                      outgoingChatBubbleConfig: ChatBubble(color: primaryColor),
                      inComingChatBubbleConfig: ChatBubble(
                        onMessageRead: (message) {
                          message.setStatus = MessageStatus.read;
                          context.read<ChatBloc>().add(
                            SeenStatus(userId: userId, chatId: chat.chatId),
                          );
                        },
                      ),
                      padding: EdgeInsets.symmetric(vertical: 1.5.w),
                    ),
                    appBar: ChatViewAppBar(
                      backArrowColor: Colors.white,
                      elevation: 2,
                      backGroundColor: Color.fromARGB(255, 10, 13, 15),
                      chatTitle: otherUser.userName,
                      chatTitleTextStyle: TextStyle(color: Colors.white),
                      imageType: ImageType.asset,
                      profilePicture:
                          'assets/Avatars/avatar${otherUser.userProfile}.jpg',
                    ),

                    chatBackgroundConfig: ChatBackgroundConfiguration(
                      loadingWidget: Center(
                        child: CupertinoActivityIndicator(color: primaryColor),
                      ),
                      messageTimeIconColor: Colors.white,
                      messageTimeTextStyle: TextStyle(color: Colors.white),
                      backgroundColor: Color.fromARGB(255, 10, 13, 15),
                      defaultGroupSeparatorConfig:
                          DefaultGroupSeparatorConfiguration(
                            padding: EdgeInsets.symmetric(vertical: 4.w),
                            textStyle: TextStyle(color: Colors.white),
                          ),
                    ),
                    chatController: state.controller!,
                    chatViewState: state.state,
                  );
            },
          ),
        ),
      ),
    );
  }
}
