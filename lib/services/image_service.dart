// lib/services/image_service.dart
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Web-specific
import 'dart:html' as html;

class ImageService {
  static Future<String?> captureSaveAndShare({
    required ScreenshotController screenshotController,
    required String caption,
  }) async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture(
        delay: const Duration(milliseconds: 200),
        pixelRatio: 2.0,
      );

      if (imageBytes == null) {
        debugPrint("❌ ScreenshotController.capture() returned null");
        return null;
      }

      if (kIsWeb) {
        // Step 1: Download the image in the browser
        final blob = html.Blob([imageBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "arcium_id.png")
          ..click();
        html.Url.revokeObjectUrl(url);
        debugPrint("✅ ID downloaded via browser");

        // Step 2: Immediately open X compose in a new tab
        final tweetUrl = Uri.parse(
          'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(caption)}',
        );
        html.window.open(tweetUrl.toString(), '_blank');

        return "downloaded_web";
      } else {
        // Mobile / desktop native
        final dir = await getTemporaryDirectory();
        final fileName =
            'arcium_id_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(imageBytes);
        debugPrint("✅ ID saved at ${file.path}");

        await Share.shareXFiles([XFile(file.path)], text: caption);
        await _openXCompose(caption);

        return file.path;
      }
    } catch (e, st) {
      debugPrint("❌ Error in captureSaveAndShare: $e");
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  static Future<void> _openXCompose(String caption) async {
    final appUri =
        Uri.parse('twitter://post?message=${Uri.encodeComponent(caption)}');

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
      return;
    }

    final webUri = Uri.parse(
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(caption)}');
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }
}
