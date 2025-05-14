// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String chatId;
  final String lastMessage;
  final List<String> participantIds;
  final DateTime lastUpdated;
  final Map<String, bool> lastMessageSeenBy; // userId -> true/false
  final Map<String, bool> isTyping; // userId -> true/false
  final Map<String, String> userProfiles; // userId -> profileUrl
  final Map<String, String> userNames; // userId -> userName

  const Chat({
    required this.chatId,
    required this.participantIds,
    required this.lastUpdated,
    required this.lastMessageSeenBy,
    required this.isTyping,
    required this.userProfiles,
    required this.userNames,
    required this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      lastMessage: json['lastMessage'],
      participantIds: List<String>.from(json['participantIds']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      lastMessageSeenBy: Map<String, bool>.from(json['lastMessageSeenBy']),
      isTyping: Map<String, bool>.from(json['isTyping']),
      userProfiles: Map<String, String>.from(json['userProfiles']),
      userNames: Map<String, String>.from(json['userNames']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'lastMessage': lastMessage,
      'participantIds': participantIds,
      'lastUpdated': lastUpdated.toIso8601String(),
      'lastMessageSeenBy': lastMessageSeenBy,
      'isTyping': isTyping,
      'userProfiles': userProfiles,
      'userNames': userNames,
    };
  }

  Chat copyWith({
    String? chatId,
    String? lastMessage,
    List<String>? participantIds,
    DateTime? lastUpdated,
    Map<String, bool>? lastMessageSeenBy,
    Map<String, bool>? isTyping,
    Map<String, String>? userProfiles,
    Map<String, String>? userNames,
  }) {
    return Chat(
      chatId: chatId ?? this.chatId,
      participantIds: participantIds ?? this.participantIds,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastMessageSeenBy: lastMessageSeenBy ?? this.lastMessageSeenBy,
      isTyping: isTyping ?? this.isTyping,
      userProfiles: userProfiles ?? this.userProfiles,
      userNames: userNames ?? this.userNames,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  OtherUserInfo getOtherUserInfo(String currentUserId) {
    final otherUserId = participantIds.firstWhere((id) => id != currentUserId);
    return OtherUserInfo(
      userId: otherUserId,
      userName: userNames[otherUserId] ?? '',
      userProfile: userProfiles[otherUserId] ?? '',
      isTyping: isTyping[otherUserId] ?? false,
      lastMessageSeenBy: lastMessageSeenBy[otherUserId] ?? false,
    );
  }

  @override
  List<Object?> get props => [
    chatId,
    participantIds,
    lastMessageSeenBy,
    lastUpdated,
    isTyping,
    userNames,
    userProfiles,
    lastMessage,
  ];
}

class OtherUserInfo {
  final String userId;
  final String userName;
  final String userProfile;
  final bool isTyping;
  final bool lastMessageSeenBy;

  OtherUserInfo({
    required this.userId,
    required this.userName,
    required this.userProfile,
    required this.isTyping,
    required this.lastMessageSeenBy,
  });
}
