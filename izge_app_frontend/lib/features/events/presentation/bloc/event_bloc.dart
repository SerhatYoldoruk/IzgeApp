import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final SupabaseService _supabaseService;

  EventBloc({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService.instance,
        super(EventInitial()) {
    
    on<EventFetchRequested>(_onEventFetchRequested);
  }

  Future<void> _onEventFetchRequested(
      EventFetchRequested event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await _supabaseService.getEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}
