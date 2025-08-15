import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String userName;
  final String country;
  final String gender;
  final bool isVerified;
  final int avatarId;
  final String about;
  final bool isSignedInWithGoogle;
  final DateTime joinDate;
  final int aura;

  const User({
    required this.id,
    required this.email,
    required this.isSignedInWithGoogle,
    required this.userName,
    required this.country,
    required this.gender,
    required this.isVerified,
    required this.avatarId,
    required this.about,
    required this.joinDate,
    required this.aura,
  });

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'country': country,
      'gender': gender,
      'isVerified': isVerified,
      'avatarId': avatarId,
      'isGoogleSignIn': isSignedInWithGoogle,
      'about': about,
      'joinDate': joinDate.toIso8601String(),
      'aura': aura,
    };
  }

  // Create User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      userName: json['userName'] as String,
      country: json['country'] as String,
      gender: json['gender'] as String,
      isVerified: json['isVerified'] as bool,
      avatarId: json['avatarId'] as int,
      about: json['about'] as String,
      isSignedInWithGoogle: json['isGoogleSignIn'] as bool,
      joinDate: DateTime.parse(json['joinDate'] as String),
      aura: json['aura'] as int,
    );
  }

  // Clone the user with updated fields
  User copyWith({
    int? id,
    String? email,
    String? userName,
    String? country,
    String? gender,
    bool? isVerified,
    int? avatarId,
    bool? isSignedInWithGoogle,
    String? about,
    DateTime? joinDate,
    int? aura,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      isVerified: isVerified ?? this.isVerified,
      avatarId: avatarId ?? this.avatarId,
      about: about ?? this.about,
      isSignedInWithGoogle: isSignedInWithGoogle ?? this.isSignedInWithGoogle,
      joinDate: joinDate ?? this.joinDate,
      aura: aura ?? this.aura,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    userName,
    country,
    gender,
    isSignedInWithGoogle,
    isVerified,
    avatarId,
    about,
    joinDate,
    aura,
  ];
}
