class ChatRoomModel {
  final int id;
  final String userId;
  final String status;
  final DateTime createdAt;

  ChatRoomModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'] as int,
      userId: map['user_id'] as String,
      status: map['status'] as String? ?? 'open',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class MessageModel {
  final int id;
  final int roomId;
  final String? senderId;
  final String messageText;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.roomId,
    this.senderId,
    required this.messageText,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as int,
      roomId: map['room_id'] as int,
      senderId: map['sender_id'] as String?,
      messageText: map['message_text'] as String,
      isRead: map['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'message_text': messageText,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
