import 'package:e_learning_app/models/course.dart';
import 'package:e_learning_app/models/lesson.dart';

class DummyDataService {
  static final List<Course> courses = [
    Course(
      id: '1',
      title: 'Flutter Development Bootcamp',
      description:
          'Learn Flutter and Dart from scratch and build real-world apps',
      imageUrl: 'https://picsum.photos/800/400?random=1',
      instructorId: 'inst_1',
      categoryId: '1', // Programming
      price: 99.99,
      lessons: _createDummyLessons(6),
      level: 'Intermediate',
      requirements: [
        'Basic programming knowledge',
        'Computer with internet connection',
        'Dedication to learn'
      ],
      whatYouWillLearn: [
        'Build beautiful native apps',
        'Learn Dart programming',
        'State management techniques',
        'API integration'
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
      rating: 4.8,
      reviewCount: 245,
      enrollmentCount: 1200,
    ),
    Course(
      id: '2',
      title: 'UI/UX Design Fundamentals',
      description:
          'Master the principles of user interface and experience design',
      imageUrl: 'https://picsum.photos/800/400?random=2',
      instructorId: 'inst_2',
      categoryId: '2', // Design
      price: 79.99,
      lessons: _createDummyLessons(8),
      level: 'Beginner',
      requirements: [
        'No prior experience needed',
        'Design software will be provided',
      ],
      whatYouWillLearn: [
        'Design principles',
        'Color theory',
        'Typography basics',
        'User research methods'
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now(),
      rating: 4.6,
      reviewCount: 189,
      enrollmentCount: 890,
    ),
    // Add more courses as needed
  ];

  static List<Lesson> _createDummyLessons(int count) {
    return List.generate(
      count,
      (index) => Lesson(
        id: 'lesson_${index + 1}',
        title: 'Lesson ${index + 1}',
        description: 'This is a detailed description for lesson ${index + 1}',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 30 + (index * 5),
        resources: _createDummyResources(),
        isPreview: index == 0,
      ),
    );
  }

  static List<Resource> _createDummyResources() {
    return [
      Resource(
        id: 'res_1',
        title: 'Lesson Slides',
        type: 'pdf',
        url: 'https://example.com/slides.pdf',
      ),
      Resource(
        id: 'res_2',
        title: 'Exercise Files',
        type: 'zip',
        url: 'https://example.com/exercises.zip',
      ),
    ];
  }

  static Course getCourseById(String id) {
    return courses.firstWhere(
      (course) => course.id == id,
      orElse: () => courses.first,
    );
  }

  static List<Course> getCoursesByCategory(String categoryId) {
    return courses.where((course) => course.categoryId == categoryId).toList();
  }
}
