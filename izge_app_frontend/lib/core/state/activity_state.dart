import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityState {
  ActivityState._();
  static final ActivityState instance = ActivityState._();

  final ValueNotifier<List<String>> likedIds = ValueNotifier<List<String>>([]);
  final ValueNotifier<List<String>> savedIds = ValueNotifier<List<String>>([]);
  final ValueNotifier<int> eventsCount = ValueNotifier<int>(0);
  final ValueNotifier<int> requestCount = ValueNotifier<int>(0);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    likedIds.value = prefs.getStringList('likedIds') ?? [];
    savedIds.value = prefs.getStringList('savedIds') ?? [];
    eventsCount.value = prefs.getInt('eventsCount') ?? 0;
    requestCount.value = prefs.getInt('requestCount') ?? 0;
  }

  Future<void> incrementRequestCount() async {
    requestCount.value++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('requestCount', requestCount.value);
  }

  Future<void> toggleLike(String id, bool isLiked) async {
    final list = List<String>.from(likedIds.value);
    if (isLiked) {
      if (!list.contains(id)) list.add(id);
    } else {
      list.remove(id);
    }
    likedIds.value = list;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('likedIds', list);
  }

  Future<void> toggleSave(String id, bool isSaved) async {
    final list = List<String>.from(savedIds.value);
    if (isSaved) {
      if (!list.contains(id)) list.add(id);
    } else {
      list.remove(id);
    }
    savedIds.value = list;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedIds', list);
  }

  Future<void> toggleEvent(bool isRegistered) async {
    if (isRegistered) {
      eventsCount.value++;
    } else {
      if (eventsCount.value > 0) eventsCount.value--;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('eventsCount', eventsCount.value);
  }
}
