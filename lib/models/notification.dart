final String tableNotifications = 'notifications';

class NotificationFields {
  static final List<String> values = [
    /// Add all fields
    id, imageUrl, title, description, time, postId
  ];

  static final String id = '_id';
  static final String imageUrl = 'imageUrl';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
  static final String postId = 'postId';
}

class Notification {
  final int? id;
  final String imageUrl;
  final String title;
  final String description;
  final DateTime createdTime;
  final String? postId;

  const Notification({
    this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.createdTime,
    this.postId,
  });

  Notification copy({
    int? id,
    String? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
    String? postId,
  }) =>
      Notification(
        id: id ?? this.id,
        imageUrl: isImportant ?? this.imageUrl,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
        postId: postId ?? this.postId,
      );

  static Notification fromJson(Map<String, Object?> json) => Notification(
        id: json[NotificationFields.id] as int?,
        imageUrl: json[NotificationFields.imageUrl] as String,
        title: json[NotificationFields.title] as String,
        description: json[NotificationFields.description] as String,
        createdTime: DateTime.parse(json[NotificationFields.time] as String),
        postId: json[NotificationFields.postId] as String?,
      );

  Map<String, Object?> toJson() => {
        NotificationFields.id: id,
        NotificationFields.title: title,
        NotificationFields.imageUrl: imageUrl,
        NotificationFields.description: description,
        NotificationFields.time: createdTime.toIso8601String(),
        NotificationFields.postId: postId,
      };
}
