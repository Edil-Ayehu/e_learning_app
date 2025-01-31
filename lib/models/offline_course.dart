class OfflineCourse {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String localImagePath;
  final List<OfflineLesson> lessons;
  final DateTime downloadedAt;

  OfflineCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.localImagePath,
    required this.lessons,
    required this.downloadedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'localImagePath': localImagePath,
        'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
        'downloadedAt': downloadedAt.toIso8601String(),
      };

  factory OfflineCourse.fromJson(Map<String, dynamic> json) => OfflineCourse(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        localImagePath: json['localImagePath'],
        lessons: (json['lessons'] as List)
            .map((lesson) => OfflineLesson.fromJson(lesson))
            .toList(),
        downloadedAt: DateTime.parse(json['downloadedAt']),
      );
}

class OfflineLesson {
  final String id;
  final String title;
  final String videoUrl;
  final String localVideoPath;
  final List<String> resourceUrls;
  final List<String> localResourcePaths;

  OfflineLesson({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.localVideoPath,
    required this.resourceUrls,
    required this.localResourcePaths,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'videoUrl': videoUrl,
        'localVideoPath': localVideoPath,
        'resourceUrls': resourceUrls,
        'localResourcePaths': localResourcePaths,
      };

  factory OfflineLesson.fromJson(Map<String, dynamic> json) => OfflineLesson(
        id: json['id'],
        title: json['title'],
        videoUrl: json['videoUrl'],
        localVideoPath: json['localVideoPath'],
        resourceUrls: List<String>.from(json['resourceUrls']),
        localResourcePaths: List<String>.from(json['localResourcePaths']),
      );
}
