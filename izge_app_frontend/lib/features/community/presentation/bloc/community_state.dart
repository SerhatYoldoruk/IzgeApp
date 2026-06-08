import 'package:equatable/equatable.dart';
import 'package:izge_app_frontend/features/community/data/models/community_post_model.dart';
import 'package:izge_app_frontend/features/community/data/models/community_reply_model.dart';

abstract class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object?> get props => [];
}

class CommunityInitial extends CommunityState {}

class CommunityLoading extends CommunityState {}

class CommunityPostsLoaded extends CommunityState {
  final List<CommunityPostModel> posts;

  const CommunityPostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class CommunityPostDetailLoaded extends CommunityState {
  final CommunityPostModel post;
  final List<CommunityReplyModel> replies;

  const CommunityPostDetailLoaded(this.post, this.replies);

  @override
  List<Object?> get props => [post, replies];
}

class CommunityError extends CommunityState {
  final String message;

  const CommunityError(this.message);

  @override
  List<Object?> get props => [message];
}

class CommunityActionSuccess extends CommunityState {
  final String message;

  const CommunityActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
