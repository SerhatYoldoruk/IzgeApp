import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final SupabaseService _supabaseService;

  NewsBloc({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService.instance,
        super(NewsInitial()) {
    
    on<NewsFetchRequested>(_onNewsFetchRequested);
  }

  Future<void> _onNewsFetchRequested(
      NewsFetchRequested event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final news = await _supabaseService.getAnnouncements();
      emit(NewsLoaded(news));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
