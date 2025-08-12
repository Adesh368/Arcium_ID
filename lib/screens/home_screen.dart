// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import '../widgets/id_form.dart';
import '../widgets/id_card.dart';
import '../providers/member_provider.dart';
import '../services/image_service.dart';
import '../utils/responsive_breakpoints.dart';
import '../theme/arcium_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // ScreenshotController used to capture the IDCard widget
  final ScreenshotController _screenshotController = ScreenshotController();
  final _formKey = GlobalKey<FormState>();

  // caption that will be shared on X (uses the sample provided plus emoji & greeting)
  String get _caption =>
      'just generated my\n@ArciumHQ\ncommunity ID! 🚀 create yours at https://arcium-id.globeapp.dev/\nencrypted supercomputer!\n☂️ gMPC';

  @override
  Widget build(BuildContext context) {
    // watch current member for preview
    final member = ref.watch(memberProvider);

    // Layout: side-by-side on wide screens, stacked on mobile
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return Scaffold(
      backgroundColor: ArciumTheme.cream,
      appBar: AppBar(
        title: const Text('Arcium ID generator'),
        backgroundColor: ArciumTheme.purple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isMobile
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                       IDForm(formKey: _formKey,),
                      const SizedBox(height: 16),
                      // Wrap the IDCard with Screenshot to allow capture
                      Screenshot(
                        controller: _screenshotController,
                        child: IDCard(member: member, width: 900, height: 560),
                      ),
                      const SizedBox(height: 12),
                      _buildActionRow(),
                    ],
                  ),
                )
              : Row(
                  children: [
                    // left: form
                    Expanded(flex: 4, child:  IDForm(formKey: _formKey,)),
                    const SizedBox(width: 18),
                    // right: preview + actions
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Screenshot(
                              controller: _screenshotController,
                              child: IDCard(member: member, width: 900, height: 560),
                            ),
                            const SizedBox(height: 12),
                            _buildActionRow(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  // Action row with the Generate & Share button
  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            // ✅ Validate form before proceeding
            if (!_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all required fields')),
              );
              return;
            }

            // Generate the image, save file and open share sheet.
            // We await the service to let user pick X or other apps.
            final savedPath = await ImageService.captureSaveAndShare(
              screenshotController: _screenshotController,
              caption: _caption,
            );

            // Optionally show a brief snackbar when saved
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    savedPath != null ? 'ID downloaded to $savedPath' : 'Failed to generate ID',
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.download_rounded),
          label: const Text('Download & Share to X'),
          style: ElevatedButton.styleFrom(
            backgroundColor: ArciumTheme.purple,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
      ],
    );
  }
}
