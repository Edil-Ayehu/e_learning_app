import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 8),
                    Text(
                      'John Doe',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      'john.doe@example.com',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileCard(
                    theme,
                    title: 'Edit Profile',
                    icon: Icons.edit,
                    onTap: () => Get.toNamed(AppRoutes.editProfile),
                  ),
                  _buildStatsCard(theme),
                  _buildProfileCard(
                    theme,
                    title: 'Notifications',
                    icon: Icons.notifications_outlined,
                    onTap: () {},
                  ),
                  _buildProfileCard(
                    theme,
                    title: 'Settings',
                    icon: Icons.settings_outlined,
                    onTap: () {},
                  ),
                  _buildProfileCard(
                    theme,
                    title: 'Help & Support',
                    icon: Icons.help_outline,
                    onTap: () {},
                  ),
                  _buildProfileCard(
                    theme,
                    title: 'Logout',
                    icon: Icons.logout,
                    onTap: () => Get.offAllNamed(AppRoutes.login),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? theme.colorScheme.error : theme.colorScheme.primary,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDestructive ? theme.colorScheme.error : null,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(theme, '12', 'Courses'),
            _buildStat(theme, '148', 'Hours'),
            _buildStat(theme, '86%', 'Success'),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(ThemeData theme, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}