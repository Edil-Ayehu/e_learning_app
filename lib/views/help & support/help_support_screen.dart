import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/views/help%20&%20support/widgets/contact_tile.dart';
import 'package:e_learning_app/views/help%20&%20support/widgets/faq_tile.dart';
import 'package:e_learning_app/views/help%20&%20support/widgets/help_search_bar.dart';
import 'package:e_learning_app/views/help%20&%20support/widgets/help_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HelpSearchBar(),
              const SizedBox(height: 24),
              const HelpSection(
                title: 'Frequently Asked Questions',
                children: [
                  FaqTile(
                    question: 'How do I reset my password?',
                    answer:
                        'Go to the login screen and tap on "Forgot Password". Follow the instructions sent to your email.',
                  ),
                  FaqTile(
                    question: 'How do I download courses for offline viewing?',
                    answer:
                        'Open a course and tap the download icon. Make sure you have enough storage space.',
                  ),
                  FaqTile(
                    question: 'Can I get a refund?',
                    answer:
                        'Yes, within 30 days of purchase if you\'re not satisfied with the course.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              HelpSection(
                title: 'Contact Us',
                children: [
                  ContactTile(
                    title: 'Email Support',
                    subtitle: 'Get help via email',
                    icon: Icons.email_outlined,
                    onTap: () {},
                  ),
                  ContactTile(
                    title: 'Live Chat',
                    subtitle: 'Chat with our support team',
                    icon: Icons.chat_outlined,
                    onTap: () {},
                  ),
                  ContactTile(
                    title: 'Call Us',
                    subtitle: 'Speak with a representative',
                    icon: Icons.phone_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
