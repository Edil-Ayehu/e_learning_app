import 'package:e_learning_app/views/courses/course_list_screen.dart';
import 'package:e_learning_app/views/quiz/quiz_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_app/blocs/navigation/navigation_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentIndex,
              children: [
                _buildHomeContent(context),
                const CourseListScreen(),
                const QuizListScreen(),
                const QuizListScreen(),
                // const ProfileScreen(), // Create this screen
              ],
            ),
            bottomNavigationBar: NavigationBar(
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.play_lesson_outlined),
                  selectedIcon: Icon(Icons.play_lesson),
                  label: 'My Courses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.quiz_outlined),
                  selectedIcon: Icon(Icons.quiz),
                  label: 'Quizzes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              selectedIndex: state.currentIndex,
              onDestinationSelected: (index) {
                context.read<NavigationBloc>().add(NavigateToTab(index));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    'JD',
                    style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      'John Doe',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(theme),
                const SizedBox(height: 24),
                _buildCategorySection(theme),
                const SizedBox(height: 24),
                _buildInProgressSection(theme),
                const SizedBox(height: 24),
                _buildRecommendedSection(theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search courses...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant,
      ),
    );
  }

  Widget _buildCategorySection(ThemeData theme) {
    final categories = [
      {'icon': Icons.code, 'label': 'Programming'},
      {'icon': Icons.brush, 'label': 'Design'},
      {'icon': Icons.business, 'label': 'Business'},
      {'icon': Icons.music_note, 'label': 'Music'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['label'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInProgressSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'In Progress',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.code,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            title: const Text('Flutter Development'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text('Progress: 60%'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.courseList),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                child: Card(
                  child: InkWell(
                    onTap: () => Get.toNamed(
                      AppRoutes.courseDetail.replaceAll(':id', index.toString()),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            'https://picsum.photos/160/90?random=$index',
                            height: 90,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Course ${index + 1}',
                                style: theme.textTheme.titleSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '2h 30m',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
