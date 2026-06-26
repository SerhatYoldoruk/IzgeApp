import '../../data/models/development_assessment_model.dart';

abstract class DevelopmentState {}

class DevelopmentInitial extends DevelopmentState {}

class DevelopmentLoading extends DevelopmentState {}

class DevelopmentLoaded extends DevelopmentState {
  final List<DevelopmentAssessment> assessments;

  DevelopmentLoaded(this.assessments);
}

class DevelopmentError extends DevelopmentState {
  final String message;

  DevelopmentError(this.message);
}
