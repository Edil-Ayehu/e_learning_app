import 'package:flutter/material.dart';
import 'package:e_learning_app/core/theme/app_colors.dart';

class ProfilePictureBottomSheet extends StatelessWidget {
  const ProfilePictureBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Change Profile Picture',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.photo_library, color: Colors.white),
            ),
            title: const Text('Choose from Gallery'),
            onTap: () {
              // TODO: Implement gallery picker
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
            title: const Text('Take a Photo'),
            onTap: () {
              // TODO: Implement camera capture
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.error,
              child: Icon(Icons.delete_outline, color: Colors.white),
            ),
            title: const Text(
              'Remove Photo',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              // TODO: Implement photo removal
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
