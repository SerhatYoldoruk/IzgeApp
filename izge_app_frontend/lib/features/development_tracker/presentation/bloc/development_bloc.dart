import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/development_repository.dart';
import 'development_event.dart';
import 'development_state.dart';

class DevelopmentBloc extends Bloc<DevelopmentEvent, DevelopmentState> {
  final DevelopmentRepository _repository;

  DevelopmentBloc({required DevelopmentRepository repository})
      : _repository = repository,
        super(DevelopmentInitial()) {
    on<FetchAssessments>(_onFetchAssessments);
    on<AddAssessment>(_onAddAssessment);
  }

  Future<void> _onFetchAssessments(
    FetchAssessments event,
    Emitter<DevelopmentState> emit,
  ) async {
    emit(DevelopmentLoading());
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(DevelopmentError('Kullanıcı girişi yapılmamış.'));
        return;
      }
      
      final assessments = await _repository.getAssessments(user.id);
      emit(DevelopmentLoaded(assessments));
    } catch (e) {
      emit(DevelopmentError('Veriler yüklenirken hata oluştu: $e'));
    }
  }

  Future<void> _onAddAssessment(
    AddAssessment event,
    Emitter<DevelopmentState> emit,
  ) async {
    try {
      await _repository.addAssessment(
        area: event.area,
        score: event.score,
        answers: event.answers,
        notes: event.notes,
      );
      
      // Kayıt eklendikten sonra listeyi tekrar çekelim
      add(FetchAssessments());
    } catch (e) {
      // Sadece konsola veya ayrı bir event'e yazabiliriz
      // Mevcut state'i bozmamak adına basit tutuyoruz.
    }
  }
}
