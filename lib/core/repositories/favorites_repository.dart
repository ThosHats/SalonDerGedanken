import 'package:hive_flutter/hive_flutter.dart';

class FavoritesRepository {
  static const String _boxName = 'favorites';

  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  Future<void> toggleFavorite(String eventId) async {
    final box = await _getBox();
    if (box.containsKey(eventId)) {
      await box.delete(eventId);
    } else {
      await box.put(eventId, eventId);
    }
  }

  Future<bool> isFavorite(String eventId) async {
    final box = await _getBox();
    return box.containsKey(eventId);
  }

  Future<Set<String>> getFavorites() async {
    final box = await _getBox();
    // Hive keys/values can be dynamic, explicit casting to ensure type safety
    return box.values.cast<String>().toSet();
  }
}
