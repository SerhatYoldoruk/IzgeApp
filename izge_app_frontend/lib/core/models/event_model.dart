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
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'İsimsiz Etkinlik',
      description: map['description']?.toString() ?? 'Açıklama belirtilmemiş',
      location: map['location']?.toString(),
      eventDate: map['event_date'] != null
          ? DateTime.tryParse(map['event_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      imageUrl: map['image_url']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
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
