// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final List<ChatItem> chats = [
    ChatItem(
      name: 'FYP',
      lastMessage: 'asfar: Photo',
      time: '2-3-2023',
      isUnread: true,
    ),
    ChatItem(
      name: 'Mess',
      lastMessage: 'asfar: This message was deleted',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'Yesterday',
      lastMessage: '5/10/25',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'phprho',
      lastMessage: 'Voice call',
      time: '',
      isUnread: false,
    ),
    ChatItem(name: 'Me (You)', lastMessage: 'Photo', time: '', isUnread: false),
    ChatItem(
      name: 'Hasnain',
      lastMessage: 'Voice call',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'Hassan Ali',
      lastMessage: 'dhyan rkhna ke number uni men registered...',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'Adil bhai',
      lastMessage: 'muaz bhai ayegy sone band nhi kma',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'Abdul Reham Cs Comsat A',
      lastMessage: 'No worries',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'RozMarrah-Comsats-2',
      lastMessage: '+92 341 0689147 joined using this gr',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'RozMarrah-Comsats-2',
      lastMessage: '+92 341 0689147 joined using this gr',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'RozMarrah-Comsats-2',
      lastMessage: '+92 341 0689147 joined using this gr',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'RozMarrah-Comsats-2',
      lastMessage: '+92 341 0689147 joined using this gr',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'RozMarrah-Comsats-2',
      lastMessage: '+92 341 0689147 joined using this gr',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'RozMarrah-Comsats-2',
      lastMessage: '+92 341 0689147 joined using this gr',
      time: '',
      isUnread: false,
    ),
    ChatItem(
      name: 'RozMarrah-Comsats-2',
      lastMessage: '+92 341 0689147 joined using this gr',
      time: '',
      isUnread: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats"), actions: []),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: chats.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                ChatItem chat = chats[index];
                return Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      chat.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(chat.lastMessage),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          chat.time,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, size: 5.w),
                          onSelected: (String value) {
                            if (value == "delete") {}
                          },
                          itemBuilder:
                              (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.white,
                                          ),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                  ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatItem {
  final String name;
  final String lastMessage;
  final String time;
  final bool isUnread;

  ChatItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isUnread,
  });
}
