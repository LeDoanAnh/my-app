import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/search_entity.dart';
import 'package:my_app/domain/usecases/search_use_case.dart';

// ── Events ───────────────────────────────────────────────────
abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final int userId;
  final String query;
  final String filter;
  SearchQueryChanged({
    required this.userId,
    required this.query,
    this.filter = 'all',
  });
}

class SearchSubmitted extends SearchEvent {
  final int userId;
  final String query;
  final String filter;
  SearchSubmitted({
    required this.userId,
    required this.query,
    this.filter = 'all',
  });
}

class SearchHistoryLoaded extends SearchEvent {}

class SearchHistoryCleared extends SearchEvent {}

class SearchHistoryItemDeleted extends SearchEvent {
  final String query;
  SearchHistoryItemDeleted(this.query);
}

// ── States ───────────────────────────────────────────────────
abstract class SearchState {}

class SearchInitial extends SearchState {
  final List<String> history;
  SearchInitial({this.history = const []});
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchResultEntity> results;
  final String query;
  SearchLoaded({required this.results, required this.query});
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

// ── Bloc ─────────────────────────────────────────────────────
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUseCase useCase;

  SearchBloc({required this.useCase}) : super(SearchInitial()) {
    on<SearchHistoryLoaded>(_onHistoryLoaded);
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchSubmitted>(_onSubmitted);
    on<SearchHistoryCleared>(_onCleared);
    on<SearchHistoryItemDeleted>(_onItemDeleted);
  }

  void _onHistoryLoaded(SearchHistoryLoaded event, Emitter emit) {
    emit(SearchInitial(history: useCase.getSearchHistory()));
  }

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter emit) async {
    if (event.query.trim().isEmpty) {
      emit(SearchInitial(history: useCase.getSearchHistory()));
      return;
    }
    emit(SearchLoading());
    try {
      final results = await useCase.search(
        event.userId,
        event.query,
        filter: event.filter,
      );
      emit(SearchLoaded(results: results, query: event.query));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSubmitted(SearchSubmitted event, Emitter emit) async {
    if (event.query.trim().isEmpty) return;
    await useCase.saveSearchHistory(event.query.trim());
    emit(SearchLoading());
    try {
      final results = await useCase.search(
        event.userId,
        event.query,
        filter: event.filter,
      );
      emit(SearchLoaded(results: results, query: event.query));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onCleared(SearchHistoryCleared event, Emitter emit) async {
    await useCase.clearSearchHistory();
    emit(SearchInitial(history: []));
  }

  Future<void> _onItemDeleted(
    SearchHistoryItemDeleted event,
    Emitter emit,
  ) async {
    await useCase.deleteSearchHistoryItem(event.query);
    emit(SearchInitial(history: useCase.getSearchHistory()));
  }
}
