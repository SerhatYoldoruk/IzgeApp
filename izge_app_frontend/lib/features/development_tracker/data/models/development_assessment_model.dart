class DevelopmentAssessment {
  final String id;
  final String userId;
  final String area;
  final double score;
  final Map<String, dynamic>? answers;
  final String? notes;
  final DateTime createdAt;

  DevelopmentAssessment({
    required this.id,
    required this.userId,
    required this.area,
    required this.score,
    this.answers,
    this.notes,
    required this.createdAt,
  });

  factory DevelopmentAssessment.fromJson(Map<String, dynamic> json) {
    return DevelopmentAssessment(
      id: json['id'],
      userId: json['user_id'],
      area: json['area'],
      score: (json['score'] as num).toDouble(),
      answers: json['answers'] as Map<String, dynamic>?,
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'area': area,
      'score': score,
      'answers': answers,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
