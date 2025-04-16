import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/my_colors.dart';

class ShareOptionsBottomSheet extends StatelessWidget {
  final String shareUrl;
  final int productCount;

  const ShareOptionsBottomSheet({
    Key? key,
    required this.shareUrl,
    required this.productCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (shareUrl.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Unable to generate share link'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Share Wishlist',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.email, color: MyColors.orange),
            title: Text('Share via Email'),
            onTap: () async {
              Navigator.pop(context);
              final emailSubject = 'Check out my toy wishlist!';
              final emailBody =
                  'I have $productCount toys in my wishlist.\n\n$shareUrl';

              final emailLaunchUri = Uri(
                scheme: 'mailto',
                query: encodeQueryParameters(<String, String>{
                  'subject': emailSubject,
                  'body': emailBody,
                }),
              );

              try {
                await launchUrl(emailLaunchUri);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unable to open email app'),
                    backgroundColor: MyColors.orange,
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.copy, color: MyColors.orange),
            title: Text('Copy Link'),
            onTap: () async {
              try {
                await Clipboard.setData(ClipboardData(text: shareUrl));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Link copied to clipboard'),
                    backgroundColor: MyColors.orange,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unable to copy link'),
                    backgroundColor: MyColors.orange,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
