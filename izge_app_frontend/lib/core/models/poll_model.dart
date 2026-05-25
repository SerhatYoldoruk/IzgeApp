class PollModel {
  final String id;
  final String title;
  final String? description;
  final List<String> options;
  final DateTime? endDate;
  final String status;
  final DateTime createdAt;
  final String? createdBy;

  PollModel({
    required this.id,
    required this.title,
    this.description,
    required this.options,
    this.endDate,
    required this.status,
    required this.createdAt,
    this.createdBy,
  });

  factory PollModel.fromMap(Map<String, dynamic> map) {
    return PollModel(
      id: map['id'].toString(),
      title: map['title'] as String,
      description: map['description'] as String?,
      options: (map['poll_options'] as List<dynamic>?)
              ?.map((e) => e['option_text'] as String)
              .toList() ??
          List<String>.from(map['options'] ?? []),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date'] as String) : null,
      status: map['status'] as String? ?? 'active',
      createdAt: DateTime.parse(map['created_at'] as String),
      createdBy: map['created_by'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'options': options,
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }
}
