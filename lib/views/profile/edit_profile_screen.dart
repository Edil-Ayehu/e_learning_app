import 'package:e_learning_app/views/profile/widgets/edit_profile_app_bar.dart';
import 'package:e_learning_app/views/profile/widgets/profile_picture_bottom_sheet.dart';
import 'package:e_learning_app/views/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: EditProfileAppBar(
        onSave: () {
          // Save profile changes
          Get.back();
        },
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
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) =>
                                const ProfilePictureBottomSheet(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CustomTextField(
                label: 'Full Name',
                prefixIcon: Icons.person_outline,
                initialValue: 'John Doe',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CustomTextField(
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                initialValue: 'john.doe@example.com',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CustomTextField(
                label: 'Phone',
                prefixIcon: Icons.phone_outlined,
                initialValue: '+1 234 567 890',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CustomTextField(
                label: 'Bio',
                prefixIcon: Icons.info_outline,
                initialValue: 'Passionate learner | Tech enthusiast',
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
