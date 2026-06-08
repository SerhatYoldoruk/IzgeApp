import 'package:equatable/equatable.dart';

abstract class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object?> get props => [];
}

class FetchCommunityPosts extends CommunityEvent {}

class FetchPostDetail extends CommunityEvent {
  final int postId;

  const FetchPostDetail(this.postId);

  @override
  List<Object?> get props => [postId];
}

class AddCommunityPost extends CommunityEvent {
  final String title;
  final String content;
  final String category;
  final String? imagePath;

  const AddCommunityPost({
    required this.title, 
    required this.content, 
    required this.category, 
    this.imagePath
  });

  @override
  List<Object?> get props => [title, content, category, imagePath];
}

class TogglePostLike extends CommunityEvent {
  final int postId;
  const TogglePostLike(this.postId);
  @override
  List<Object?> get props => [postId];
}

class AcceptReply extends CommunityEvent {
  final int replyId;
  final int postId;
  const AcceptReply({required this.replyId, required this.postId});
  @override
  List<Object?> get props => [replyId, postId];
}

class ReportContent extends CommunityEvent {
  final int? postId;
  final int? replyId;
  final String reason;

  const ReportContent({this.postId, this.replyId, required this.reason});

  @override
  List<Object?> get props => [postId, replyId, reason];
}

class AddCommunityReply extends CommunityEvent {
  final int postId;
  final String content;

  const AddCommunityReply({required this.postId, required this.content});

  @override
  List<Object?> get props => [postId, content];
}
