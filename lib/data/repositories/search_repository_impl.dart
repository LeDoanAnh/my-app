import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/local/search_history_box.dart';
import 'package:my_app/domain/entities/search_entity.dart';
import 'package:my_app/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final AuthApi api;
  SearchRepositoryImpl(this.api);

  @override
  Future<List<SearchResultEntity>> search(
      int userId,
      String query, {
        String filter = 'all',
      }) async {
    try {
      final res = await api.search(userId, query, filter: filter);
      return res.data
          ?.map((m) => SearchResultEntity(
        id: m.id ?? 0,
        title: m.title ?? '-',
        category: m.category ?? 'unknown',
        status: m.status ?? '-',
        refId: m.refId ?? m.id ?? 0,
      ))
          .toList() ?? [];
    } catch (e) {
      throw Exception('Tìm kiếm thất bại: $e');
    }
  }

  @override
  List<String> getSearchHistory() => SearchHistoryBox.getAll();

  @override
  Future<void> saveSearchHistory(String query) =>
      SearchHistoryBox.save(query);

  @override
  Future<void> clearSearchHistory() => SearchHistoryBox.clearAll();

  @override
  Future<void> deleteSearchHistoryItem(String query) =>
      SearchHistoryBox.delete(query);
}