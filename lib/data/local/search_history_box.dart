import 'package:hive_ce/hive.dart';

class SearchHistoryBox {
  static const String _boxName = 'search_history';
  static const int _maxHistory = 10;

  static Box<String> get _box => Hive.box<String>(_boxName);

  static Future<void> init() async {
    await Hive.openBox<String>(_boxName);
  }

  static List<String> getAll() {
    return _box.values.toList().reversed.toList();
  }

  static Future<void> save(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    // Xoá nếu đã tồn tại (tránh trùng)
    final existing = _box.values.toList();
    for (int i = 0; i < existing.length; i++) {
      if (existing[i] == trimmed) {
        await _box.deleteAt(i);
        break;
      }
    }

    // Giới hạn tối đa 10 lịch sử
    if (_box.length >= _maxHistory) {
      await _box.deleteAt(0);
    }

    await _box.add(trimmed);
  }

  static Future<void> delete(String query) async {
    final existing = _box.values.toList();
    for (int i = 0; i < existing.length; i++) {
      if (existing[i] == query) {
        await _box.deleteAt(i);
        break;
      }
    }
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }
}