import 'package:equatable/equatable.dart';
import 'package:izge_app_frontend/core/models/announcement_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<AnnouncementModel> news;

  const NewsLoaded(this.news);

  @override
  List<Object?> get props => [news];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}
