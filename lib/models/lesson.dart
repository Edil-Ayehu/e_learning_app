class Lesson {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final int duration;
  final List<Resource> resources;
  final bool isPreview;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.duration,
    required this.resources,
    this.isPreview = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        videoUrl: json['videoUrl'],
        duration: json['duration'],
        resources: (json['resources'] as List)
            .map((resource) => Resource.fromJson(resource))
            .toList(),
        isPreview: json['isPreview'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'videoUrl': videoUrl,
        'duration': duration,
        'resources': resources.map((resource) => resource.toJson()).toList(),
        'isPreview': isPreview,
      };

  String get videoStreamUrl {
    // Add your video streaming URL logic here
    // This could be a direct URL or a function to generate a signed URL
    return videoUrl;
  }
}

class Resource {
  final String id;
  final String title;
  final String type;
  final String url;

  Resource({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
        id: json['id'],
        title: json['title'],
        type: json['type'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'url': url,
      };
}
