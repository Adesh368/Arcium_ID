// lib/providers/member_provider.dart
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';

/// MemberNotifier is a StateNotifier that holds the current Member object
/// and provides methods to update the member state in a controlled way.
class MemberNotifier extends StateNotifier<Member> {
  // start with a default, empty Member
  MemberNotifier() : super(const Member());

  // update name and emit a new state
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  // update the join date
  void updateDateJoined(DateTime date) {
    state = state.copyWith(dateJoined: date);
  }

  // update discord username
  void updateDiscordUsername(String username) {
    state = state.copyWith(discordUsername: username);
  }

  // update role
  void updateDiscordRole(String role) {
    state = state.copyWith(discordRole: role);
  }

  // update country
  void updateCountry(String country) {
    state = state.copyWith(country: country);
  }

  // reset the member to defaults
  void reset() {
    state = const Member();
  }

  void updateAvatar(Uint8List bytes) {
    state = state.copyWith(avatarBytes: bytes);
  }

}

/// The provider object used in the UI to read & update the Member
final memberProvider = StateNotifierProvider<MemberNotifier, Member>((ref) {
  return MemberNotifier();
});
