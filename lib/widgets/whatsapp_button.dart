import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';

class WhatsAppButton extends StatelessWidget {
  final String phoneNumber;
  final String? message;

  const WhatsAppButton({
    super.key,
    required this.phoneNumber,
    this.message,
  });

  Future<void> _openWhatsApp(BuildContext context) async {
    // Remove spaces and format the phone number
    String formattedPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');

    // Ensure phone number starts with country code
    if (!formattedPhone.startsWith('+')) {
      // Assuming Egyptian number, add +20
      formattedPhone = '+2$formattedPhone';
    }

    // Create WhatsApp URL
    String whatsappUrl = 'https://wa.me/$formattedPhone';

    // Add message if provided
    if (message != null && message!.isNotEmpty) {
      String encodedMessage = Uri.encodeComponent(message!);
      whatsappUrl += '?text=$encodedMessage';
    }

    final Uri url = Uri.parse(whatsappUrl);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open WhatsApp'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _openWhatsApp(context),
      icon: const Icon(Icons.chat, size: 20),
      label: Text(
        AppLocalizations.of(context)?.contactViaWhatsapp ??
            'Contact via WhatsApp',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF25D366), // WhatsApp green color
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    );
  }
}
