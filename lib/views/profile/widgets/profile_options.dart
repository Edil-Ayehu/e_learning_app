import 'package:e_learning_app/blocs/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/core/utils/app_dialogs.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:e_learning_app/views/profile/widgets/profile_option_card.dart';

import '../../../blocs/auth/auth_bloc.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileOptionCard(
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          icon: Icons.edit_outlined,
          onTap: () => Get.toNamed(AppRoutes.editProfile),
        ),
        ProfileOptionCard(
          title: 'Notifications',
          subtitle: 'Manage your notifications',
          icon: Icons.notifications_outlined,
          onTap: () => Get.toNamed(AppRoutes.notifications),
        ),
        ProfileOptionCard(
          title: 'Settings',
          subtitle: 'App preferences and more',
          icon: Icons.settings_outlined,
          onTap: () => Get.toNamed(AppRoutes.settings),
        ),
        ProfileOptionCard(
          title: 'Help & Support',
          subtitle: 'Get help or contact support',
          icon: Icons.help_outline,
          onTap: () => Get.toNamed(AppRoutes.helpSupport),
        ),
        ProfileOptionCard(
          title: 'Logout',
          subtitle: 'Sign out of your account',
          icon: Icons.logout,
           onTap: () async {
            final confirm = await AppDialogs.showLogoutDialog();
            if (confirm == true) {
              context.read<AuthBloc>().add(LogoutRequested());
            }
          },
          isDestructive: true,
        ),
      ],
    );
  }
}
