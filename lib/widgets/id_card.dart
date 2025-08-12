// lib/widgets/id_card.dart
import 'package:arcium_id_card/providers/member_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/member.dart';
import '../theme/arcium_theme.dart';

/// IDCard is a pure UI widget that paints the member's ID card.
/// It receives a Member model and paints the information accordingly.
/// This widget is safe to capture using ScreenshotController.
class IDCard extends ConsumerWidget {
  // data to display
  final Member member;

  // fixed width/height to give predictable generated image dimensions
  final double width;
  final double height;

  const IDCard({
    Key? key,
    required this.member,
    this.width = 1000,
    this.height = 620,
  }) : super(key: key);

  // helper to create initials (used for fallback avatar)
  String get initials {
    final parts = member.name.trim().split(' ');
    if (parts.isEmpty) return 'A';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // main container: fixed size, rounded corners and gradient background
    return Center(
        child: Container(
            width: width,
            height: height,
            // decoration: gradient, shadow, rounded corners
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  ArciumTheme.purple, // #6e26e6
                  ArciumTheme.purpleDark, // #3f1289
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            // content area
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // top row: logo + "Arcium" + network
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // logo circle container
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          // show the logo asset; fallback to initials if asset missing
                          child: Image.asset(
                            'assets/images/arcium_logo.jpg',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // fallback: initials in a circle
                              return Center(
                                child: Text(
                                  initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // brand name + network
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Community handle
                            const Row(
                              children: [
                                Text(
                                  'Arcium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                SizedBox(width: 8),
                                // small brand emoji
                                Text(
                                  '☂️',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // Network / small caption
                            Text(
                              'Community ID • Built on Solana',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // small status chip (role or placeholder)
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            member.discordRole.isNotEmpty
                                ? member.discordRole
                                : 'Community',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // main info area: left = avatar & basic, right = details
                  Expanded(
                    child: Row(
                      children: [
                        // left column: avatar & name
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Avatar: clickable to change
                                    GestureDetector(
                                      onTap: () async {
                                        final picker = ImagePicker();
                                        final pickedFile =
                                            await picker.pickImage(
                                                source: ImageSource.gallery);
                                        if (pickedFile != null) {
                                          final bytes =
                                              await pickedFile.readAsBytes();
                                          ref
                                              .read(memberProvider.notifier)
                                              .updateAvatar(bytes);
                                        }
                                      },
                                      child: Container(
                                        width: 160,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.14),
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: member.avatarBytes != null
                                              ? Image.memory(
                                                  member.avatarBytes!,
                                                  fit: BoxFit.cover)
                                              : Center(
                                                  child: Icon(
                                                    Icons
                                                        .add_a_photo, // Camera/photo add icon
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    size: 48,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    Text(
                                      member.name.isNotEmpty
                                          ? member.name
                                          : 'Your name',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      member.discordUsername.isNotEmpty
                                          ? member.discordUsername
                                          : 'discord#0000',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // right column: details list
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // label + value rows
                                      const Text(
                                        'Member details',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      buildRow(
                                          'Joined',
                                          member.dateJoined != null
                                              ? DateFormat.yMMMd()
                                                  .format(member.dateJoined!)
                                              : '—'),

                                      buildRow(
                                          'Role',
                                          member.discordRole.isNotEmpty
                                              ? member.discordRole
                                              : '—'),

                                      buildRow(
                                          'Country',
                                          member.country.isNotEmpty
                                              ? member.country
                                              : '—'),

                                      const Spacer(),

                                      // footer: greeting + id hint (gMPC & small text)
                                      Row(
                                        children: [
                                          // greeting or small badge
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.08),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              'gMPC',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          // small hint
                                          Expanded(
                                            child: Text(
                                              'Encrypted supercomputer • Verified member',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.85),
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  // small helper to build label-value rows
  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
