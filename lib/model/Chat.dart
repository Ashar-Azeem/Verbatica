// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String chatId;
  final String lastMessage;
  final List<int> participantIds;
  final DateTime lastUpdated;
  final Map<int, bool> lastMessageSeenBy;
  final Map<int, int> userProfiles;
  final Map<int, String> userNames;
  final Map<int, String> publicKeys;

  const Chat({
    required this.chatId,
    required this.participantIds,
    required this.lastUpdated,
    required this.lastMessageSeenBy,
    required this.userProfiles,
    required this.userNames,
    required this.publicKeys,
    required this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    Map<int, T> parseMap<T>(Map<String, dynamic> map) {
      return map.map((key, value) => MapEntry(int.parse(key), value as T));
    }

    return Chat(
      chatId: json['chatId'],
      lastMessage: json['lastMessage'],
      participantIds: List<int>.from(json['participantIds']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      lastMessageSeenBy: parseMap<bool>(json['lastMessageSeenBy']),
      publicKeys: parseMap<String>(json['publicKeys']),
      userProfiles: parseMap<int>(json['userProfiles']),
      userNames: parseMap<String>(json['userNames']),
    );
  }

  Chat copyWith({
    String? chatId,
    String? lastMessage,
    List<int>? participantIds,
    DateTime? lastUpdated,
    Map<int, bool>? lastMessageSeenBy,
    Map<int, bool>? isTyping,
    Map<int, int>? userProfiles,
    Map<int, String>? publicKeys,
    Map<int, String>? userNames,
  }) {
    return Chat(
      chatId: chatId ?? this.chatId,
      participantIds: participantIds ?? this.participantIds,
      publicKeys: publicKeys ?? this.publicKeys,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastMessageSeenBy: lastMessageSeenBy ?? this.lastMessageSeenBy,
      userProfiles: userProfiles ?? this.userProfiles,
      userNames: userNames ?? this.userNames,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  OtherUserInfo getOtherUserInfo(int currentUserId) {
    final otherUserId = participantIds.firstWhere((id) => id != currentUserId);
    return OtherUserInfo(
      userId: otherUserId,
      userName: userNames[otherUserId]!,
      userProfile: userProfiles[otherUserId]!,
      lastMessageSeenBy: lastMessageSeenBy[otherUserId] ?? false,
      publicKey: publicKeys[otherUserId]!,
    );
  }

  @override
  List<Object?> get props => [
    chatId,
    participantIds,
    lastMessageSeenBy,
    lastUpdated,
    userNames,
    publicKeys,
    userProfiles,
    lastMessage,
  ];
}

class OtherUserInfo {
  final int userId;
  final String userName;
  final int userProfile;
  final bool lastMessageSeenBy;
  final String publicKey;

  OtherUserInfo({
    required this.userId,
    required this.userName,
    required this.userProfile,
    required this.publicKey,
    required this.lastMessageSeenBy,
  });
}
