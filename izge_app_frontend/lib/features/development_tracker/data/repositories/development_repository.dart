import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/development_assessment_model.dart';

class DevelopmentRepository {
  final SupabaseClient _supabaseClient;

  DevelopmentRepository({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  Future<List<DevelopmentAssessment>> getAssessments(String userId) async {
    final response = await _supabaseClient
        .from('development_assessments')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    return (response as List<dynamic>)
        .map((e) => DevelopmentAssessment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DevelopmentAssessment> addAssessment({
    required String area,
    required double score,
    Map<String, dynamic>? answers,
    String? notes,
  }) async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final data = {
      'user_id': user.id,
      'area': area,
      'score': score,
      'answers': ?answers,
      'notes': ?notes,
    };

    final response = await _supabaseClient
        .from('development_assessments')
        .insert(data)
        .select()
        .single();

    return DevelopmentAssessment.fromJson(response);
  }
}
