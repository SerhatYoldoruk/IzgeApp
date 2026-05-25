import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'survey_event.dart';
import 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SupabaseService _supabaseService;

  SurveyBloc({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService.instance,
        super(SurveyInitial()) {
    
    on<SurveyFetchRequested>(_onSurveyFetchRequested);
  }

  Future<void> _onSurveyFetchRequested(
      SurveyFetchRequested event, Emitter<SurveyState> emit) async {
    emit(SurveyLoading());
    try {
      final surveys = await _supabaseService.getPolls();
      emit(SurveyLoaded(surveys));
    } catch (e) {
      emit(SurveyError(e.toString()));
    }
  }
}
