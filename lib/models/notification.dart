final String tableNotifications = 'notifications';

class NotificationFields {
  static final List<String> values = [
    /// Add all fields
    id, imageUrl, title,  body, description, time, htmlBody, category,
  ];

  static final String id = '_id';
  static final String imageUrl = 'imageUrl';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
  static final String body = 'body';
  static final String htmlBody = 'htmlBody';
  static final String category = 'category';
}

class Notification {
  final int? id;
  final String imageUrl;
  final String title;
  final String description;
  final DateTime createdTime;
  final String htmlBody;
  final int category;
  final String body;

  const Notification({
    this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.htmlBody,
    required this.category,
    required this.body,
  });

  Notification copy({
    int? id,
    String? isImportant,
    int? number,
    String? title,
    String? description,
    String? body,
    String? htmlBody,
    int? category,
    DateTime? createdTime,
  }) =>
      Notification(
        id: id ?? this.id,
        imageUrl: isImportant ?? this.imageUrl,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
        body: body ?? this.body,
        htmlBody: htmlBody ?? this.htmlBody,
        category: category ?? this.category,
      );

  static Notification fromJson(Map<String, Object?> json) => Notification(
        id: json[NotificationFields.id] as int?,
        imageUrl: json[NotificationFields.imageUrl] as String,
        title: json[NotificationFields.title] as String,
        description: json[NotificationFields.description] as String,
        createdTime: DateTime.parse(json[NotificationFields.time] as String),
        body: json[NotificationFields.body] as String,
        htmlBody: json[NotificationFields.htmlBody] as String,
        category: json[NotificationFields.category] as int,
      );

  Map<String, Object?> toJson() => {
        NotificationFields.id: id,
        NotificationFields.title: title,
        NotificationFields.imageUrl: imageUrl,
        NotificationFields.description: description,
        NotificationFields.time: createdTime.toIso8601String(),
        NotificationFields.body: body,
        NotificationFields.htmlBody: htmlBody,
        NotificationFields.category: category,
      };
}
