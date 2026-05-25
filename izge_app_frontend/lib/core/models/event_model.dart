class EventModel {
  final String id;
  final String title;
  final String description;
  final String? location;
  final DateTime eventDate;
  final String? imageUrl;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.location,
    required this.eventDate,
    this.imageUrl,
    required this.createdAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'].toString(),
      title: map['title'] as String,
      description: map['description'] as String,
      location: map['location'] as String?,
      eventDate: DateTime.parse(map['event_date'] as String),
      imageUrl: map['image_url'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'event_date': eventDate.toIso8601String(),
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
