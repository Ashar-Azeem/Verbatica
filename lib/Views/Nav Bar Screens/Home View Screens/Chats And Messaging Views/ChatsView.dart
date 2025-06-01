// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:verbatica/BLOC/Chat%20Bloc/chat_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/Chats%20And%20Messaging%20Views/MessageView.dart';
import 'package:verbatica/model/Chat.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Chats",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return state.initialLoading
                ? Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Center(
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: Theme.of(context).colorScheme.primary,
                      size: 13.w,
                    ),
                  ),
                )
                : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.chats.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Chat chat = state.chats[index];
                    final otherUserData = chat.getOtherUserInfo(
                      context.read<UserBloc>().state.user.userId,
                    );
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 1.5.w,
                          right: 1.5.w,
                          top: 0.8.h,
                        ),
                        child: Stack(
                          children: [
                            Card(
                              color: Theme.of(context).cardColor,
                              child: InkWell(
                                onTap: () {
                                  pushScreen(
                                    context,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.platform,
                                    screen: MessageView(chat: chat),

                                    withNavBar: false,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                        backgroundImage: AssetImage(
                                          'assets/Avatars/avatar${otherUserData.userProfile}.jpg',
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              otherUserData.userName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.color,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              chat.lastMessage,
                                              style: TextStyle(
                                                color:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color,
                                                fontSize: 12,
                                                fontWeight:
                                                    !chat.lastMessageSeenBy[context
                                                            .read<UserBloc>()
                                                            .state
                                                            .user
                                                            .userId]!
                                                        ? FontWeight.bold
                                                        : FontWeight.w300,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            timeago.format(chat.lastUpdated),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color
                                                  ?.withOpacity(0.6),
                                              fontSize: 10,
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: Icon(
                                              Icons.more_vert,
                                              size: 20,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).iconTheme.color,
                                            ),
                                            color:
                                                Theme.of(
                                                  context,
                                                ).popupMenuTheme.color,
                                            onSelected: (String value) {
                                              if (value == "delete") {
                                                context.read<ChatBloc>().add(
                                                  DeleteChat(index: index),
                                                );
                                              }
                                            },
                                            itemBuilder:
                                                (
                                                  BuildContext context,
                                                ) => <PopupMenuEntry<String>>[
                                                  PopupMenuItem<String>(
                                                    value: 'delete',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .delete_outline_rounded,
                                                          color:
                                                              Theme.of(
                                                                context,
                                                              ).iconTheme.color,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (!chat.lastMessageSeenBy[context
                                .read<UserBloc>()
                                .state
                                .user
                                .userId]!)
                              Positioned(
                                top: 2.5.w,
                                left: 2.5.w,
                                child: Icon(
                                  Icons.circle,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 2.w,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
          },
        ),
      ),
    );
  }
}
