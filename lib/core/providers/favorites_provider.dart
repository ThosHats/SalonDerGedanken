import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_der_gedanken/core/repositories/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repository);
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _repository.getFavorites();
    state = favorites;
  }

  Future<void> toggleFavorite(String eventId) async {
    await _repository.toggleFavorite(eventId);
    // Reload state to ensure consistency or optimize by local update
    final isFav = state.contains(eventId);
    if (isFav) {
      state = state.difference({eventId});
    } else {
      state = {...state, eventId};
    }
  }
}
