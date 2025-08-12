// lib/models/member.dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

@immutable
class Member {
  final String name;
  final DateTime? dateJoined;
  final String discordUsername;
  final String discordRole;
  final String country;

  // New: store the uploaded avatar image bytes
  final Uint8List? avatarBytes;

  const Member({
    this.name = '',
    this.dateJoined,
    this.discordUsername = '',
    this.discordRole = '',
    this.country = '',
    this.avatarBytes,
  });

  Member copyWith({
    String? name,
    DateTime? dateJoined,
    String? discordUsername,
    String? discordRole,
    String? country,
    Uint8List? avatarBytes,
  }) {
    return Member(
      name: name ?? this.name,
      dateJoined: dateJoined ?? this.dateJoined,
      discordUsername: discordUsername ?? this.discordUsername,
      discordRole: discordRole ?? this.discordRole,
      country: country ?? this.country,
      avatarBytes: avatarBytes ?? this.avatarBytes,
    );
  }
}
