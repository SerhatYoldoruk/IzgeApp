class CommunityPostModel {
  final int id;
  final String userId;
  final String title;
  final String content;
  final int likesCount;
  final int repliesCount;
  final DateTime createdAt;
  final String? userName;
  final String? userAvatar;
  final String category;
  final String? imageUrl;

  CommunityPostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.likesCount,
    required this.repliesCount,
    required this.createdAt,
    this.userName,
    this.userAvatar,
    required this.category,
    this.imageUrl,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      likesCount: json['likes_count'] as int? ?? 0,
      repliesCount: json['replies_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      userName: json['profiles']?['full_name'] as String?,
      userAvatar: json['profiles']?['avatar_url'] as String?,
      category: json['category'] as String? ?? 'Genel',
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'content': content,
      'category': category,
      'image_url': imageUrl,
    };
  }
}
