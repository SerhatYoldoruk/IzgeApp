import 'package:flutter/foundation.dart';

class ActivityState {
  ActivityState._();
  static final ActivityState instance = ActivityState._();

  final ValueNotifier<int> likedCount = ValueNotifier<int>(12);
  final ValueNotifier<int> savedCount = ValueNotifier<int>(8);
  final ValueNotifier<int> eventsCount = ValueNotifier<int>(3);

  void toggleLike(bool isLiked) {
    if (isLiked) {
      likedCount.value++;
    } else {
      if (likedCount.value > 0) likedCount.value--;
    }
  }

  void toggleSave(bool isSaved) {
    if (isSaved) {
      savedCount.value++;
    } else {
      if (savedCount.value > 0) savedCount.value--;
    }
  }

  void toggleEvent(bool isRegistered) {
    if (isRegistered) {
      eventsCount.value++;
    } else {
      if (eventsCount.value > 0) eventsCount.value--;
    }
  }
}
