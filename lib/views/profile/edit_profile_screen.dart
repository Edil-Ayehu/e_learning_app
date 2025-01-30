import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Save profile changes
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      'JD',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18),
                        color: theme.colorScheme.onPrimary,
                        onPressed: () {
                          // Handle image upload
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              theme,
              label: 'Full Name',
              initialValue: 'John Doe',
              icon: Icons.person_outline,
            ),
            _buildTextField(
              theme,
              label: 'Email',
              initialValue: 'john.doe@example.com',
              icon: Icons.email_outlined,
            ),
            _buildTextField(
              theme,
              label: 'Phone',
              initialValue: '+1 234 567 890',
              icon: Icons.phone_outlined,
            ),
            _buildTextField(
              theme,
              label: 'Bio',
              initialValue: 'Passionate learner | Tech enthusiast',
              icon: Icons.info_outline,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    ThemeData theme, {
    required String label,
    required String initialValue,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        ),
      ),
    );
  }
}
