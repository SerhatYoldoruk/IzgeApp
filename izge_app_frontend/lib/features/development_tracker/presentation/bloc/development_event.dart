abstract class DevelopmentEvent {}

class FetchAssessments extends DevelopmentEvent {}

class AddAssessment extends DevelopmentEvent {
  final String area;
  final double score;
  final Map<String, dynamic>? answers;
  final String? notes;

  AddAssessment({
    required this.area,
    required this.score,
    this.answers,
    this.notes,
  });
}
