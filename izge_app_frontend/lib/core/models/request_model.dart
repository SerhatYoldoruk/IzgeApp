class RequestModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String requestType;
  final String status;
  final DateTime createdAt;

  RequestModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.requestType,
    required this.status,
    required this.createdAt,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    // created_at can come as String (ISO) or DateTime depending on client/server
    final createdAtValue = map['created_at'];
    DateTime createdAt;
    if (createdAtValue is DateTime) {
      createdAt = createdAtValue;
    } else if (createdAtValue is String) {
      createdAt = DateTime.tryParse(createdAtValue) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return RequestModel(
      id: map['id'].toString(),
      userId: map['user_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      requestType: map['request_type'] as String,
      status: map['status'] as String? ?? 'pending',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'request_type': requestType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
