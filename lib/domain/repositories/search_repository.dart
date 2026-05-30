import 'package:my_app/domain/entities/search_entity.dart';

abstract class SearchRepository {
  Future<List<SearchResultEntity>> search(
      int userId,
      String query, {
        String filter = 'all',
      });

  // Hive CE - local history
  List<String> getSearchHistory();
  Future<void> saveSearchHistory(String query);
  Future<void> clearSearchHistory();
  Future<void> deleteSearchHistoryItem(String query);
}