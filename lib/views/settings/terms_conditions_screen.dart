import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: March 15, 2024',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              theme,
              title: '1. Acceptance of Terms',
              content: 'By accessing and using EduLearn Pro, you agree to be bound by these Terms and Conditions and all applicable laws and regulations.',
            ),
            _buildSection(
              theme,
              title: '2. User Accounts',
              content: 'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
            ),
            _buildSection(
              theme,
              title: '3. Course Content',
              content: 'All course content is protected by copyright and other intellectual property rights. You may not share, reproduce, or distribute the content without explicit permission.',
            ),
            _buildSection(
              theme,
              title: '4. Payment Terms',
              content: 'Course fees are non-refundable unless otherwise specified. We reserve the right to modify pricing at any time.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
