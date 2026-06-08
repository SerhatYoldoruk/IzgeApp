class CommunityReplyModel {
  final int id;
  final int postId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final String? userName;
  final String? userAvatar;
  final bool isAccepted;

  CommunityReplyModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.userName,
    this.userAvatar,
    required this.isAccepted,
  });

  factory CommunityReplyModel.fromJson(Map<String, dynamic> json) {
    return CommunityReplyModel(
      id: json['id'] as int,
      postId: json['post_id'] as int,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      userName: json['profiles']?['full_name'] as String?,
      userAvatar: json['profiles']?['avatar_url'] as String?,
      isAccepted: json['is_accepted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'content': content,
    };
  }
}
