import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:e_learning_app/views/courses/course_list_screen.dart';
import 'package:e_learning_app/views/home/widgets/category_section.dart';
import 'package:e_learning_app/views/home/widgets/home_app_bar.dart';
import 'package:e_learning_app/views/home/widgets/in_progress_section.dart';
import 'package:e_learning_app/views/home/widgets/recommended_section.dart';
import 'package:e_learning_app/views/home/widgets/search_bar_widget.dart';
import 'package:e_learning_app/views/profile/profile_screen.dart';
import 'package:e_learning_app/views/quiz/quiz_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_app/blocs/navigation/navigation_bloc.dart';
import 'package:e_learning_app/models/category.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';


class HomeScreen extends StatelessWidget {
  final int? initialIndex;
  
  HomeScreen({
    super.key,
    this.initialIndex,
  });

  final List<Category> categories = [
    Category(
      id: '1',
      name: 'Programming',
      icon: Icons.code,
      courseCount: DummyDataService.getCoursesByCategory('1').length,
    ),
    Category(
      id: '2',
      name: 'Design',
      icon: Icons.brush,
      courseCount: DummyDataService.getCoursesByCategory('2').length,
    ),
    Category(
      id: '3',
      name: 'Business',
      icon: Icons.business,
      courseCount: DummyDataService.getCoursesByCategory('3').length,
    ),
    Category(
      id: '4',
      name: 'Music',
      icon: Icons.music_note,
      courseCount: DummyDataService.getCoursesByCategory('4').length,
    ),
    Category(
      id: '5',
      name: 'Photography',
      icon: Icons.camera_alt,
      courseCount: DummyDataService.getCoursesByCategory('5').length,
    ),
    Category(
      id: '6',
      name: 'Language',
      icon: Icons.language,
      courseCount: DummyDataService.getCoursesByCategory('6').length,
    ),
    Category(
      id: '7',
      name: 'Health & Fitness',
      icon: Icons.fitness_center,
      courseCount: DummyDataService.getCoursesByCategory('7').length,
    ),
    Category(
      id: '8',
      name: 'Personal Development',
      icon: Icons.psychology,
      courseCount: DummyDataService.getCoursesByCategory('8').length,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc()..add(
        NavigateToTab(initialIndex ?? 0)
      ),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: IndexedStack(
              index: state.currentIndex,
              children: [
                _buildHomeContent(context),
                const CourseListScreen(),
                const QuizListScreen(),
                const ProfileScreen(),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: AppColors.accent,
              indicatorColor: AppColors.primary.withOpacity(0.1),
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

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const HomeAppBar(),
        SliverPadding(
          padding: const EdgeInsets.all(20), // Consistent padding
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SearchBarWidget(),
              const SizedBox(height: 32),
              CategorySection(categories: categories),
              const SizedBox(height: 32),
              const InProgressSection(),
              const SizedBox(height: 32),
              const RecommendedSection(),
            ]),
          ),
        ),
      ],
    );
  }
}
