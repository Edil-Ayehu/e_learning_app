import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/core/utils/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: isDark
                            ? AppColors.primaryLight
                            : AppColors.lightSurface,
                        child: Text(
                          'JD',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color:
                                isDark ? AppColors.accent : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'John Doe',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'john.doe@example.com',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.accent.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatsCard(theme, isDark),
                  const SizedBox(height: 24),
                  ..._buildProfileOptions(theme, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProfileOptions(ThemeData theme, bool isDark) {
    return [
      _buildProfileCard(
        theme,
        title: 'Edit Profile',
        subtitle: 'Update your personal information',
        icon: Icons.edit_outlined,
        onTap: () => Get.toNamed(AppRoutes.editProfile),
        isDestructive: false,
      ),
      _buildProfileCard(
        theme,
        title: 'Notifications',
        subtitle: 'Manage your notifications',
        icon: Icons.notifications_outlined,
        onTap: () => Get.toNamed(AppRoutes.notifications),
        isDestructive: false,
      ),
      _buildProfileCard(
        theme,
        title: 'Settings',
        subtitle: 'App preferences and more',
        icon: Icons.settings_outlined,
        onTap: () => Get.toNamed(AppRoutes.settings),
        isDestructive: false,
      ),
      _buildProfileCard(
        theme,
        title: 'Help & Support',
        subtitle: 'Get help or contact support',
        icon: Icons.help_outline,
        onTap: () => Get.toNamed(AppRoutes.helpSupport),
        isDestructive: false,
      ),
      _buildProfileCard(
        theme,
        title: 'Logout',
        subtitle: 'Sign out of your account',
        icon: Icons.logout,
        onTap: () async {
          final confirm = await AppDialogs.showLogoutDialog();
          if (confirm == true) {
            Get.offAllNamed(AppRoutes.login);
          }
        },
        isDestructive: true,
      ),
    ];
  }

  Widget _buildProfileCard(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDestructive ? AppColors.error : AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDestructive
                              ? AppColors.error
                              : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(theme, '12', 'Courses', isDark),
            _buildStat(theme, '148', 'Hours', isDark),
            _buildStat(theme, '86%', 'Success', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(ThemeData theme, String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
