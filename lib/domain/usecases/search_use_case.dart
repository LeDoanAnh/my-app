import 'package:my_app/domain/entities/search_entity.dart';
import 'package:my_app/domain/repositories/search_repository.dart';

class SearchUseCase {
  final SearchRepository repository;
  SearchUseCase({required this.repository});

  Future<List<SearchResultEntity>> search(
      int userId,
      String query, {
        String filter = 'all',
      }) => repository.search(userId, query, filter: filter);

  List<String> getSearchHistory() => repository.getSearchHistory();

  Future<void> saveSearchHistory(String query) =>
      repository.saveSearchHistory(query);

  Future<void> clearSearchHistory() => repository.clearSearchHistory();

  Future<void> deleteSearchHistoryItem(String query) =>
      repository.deleteSearchHistoryItem(query);
}