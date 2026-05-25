class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final bool isPinned;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.isPinned,
    required this.createdAt,
  });

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'].toString(),
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String?,
      isPinned: map['is_pinned'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'is_pinned': isPinned,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
