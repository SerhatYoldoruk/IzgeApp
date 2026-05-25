class ProfileModel {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final String role;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.phone,
    required this.role,
    required this.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      phone: map['phone'] as String?,
      role: map['role'] as String? ?? 'user',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Checks if the user is an admin
  bool get isAdmin => role == 'admin';
}
