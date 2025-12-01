
import 'package:riverpod/riverpod.dart';
import '../models/wine.dart';
import '../services/wine.dart';

class WineListNotifier extends StateNotifier<AsyncValue<List<Wine>>> {
  WineListNotifier() : super(const AsyncValue.loading()) {
    _loadWines();
  }

  Future<void> _loadWines() async {
    try {
      final wines = await fetchRedWines();
      state = AsyncValue.data(wines);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Provider qui keepAlive les données
final wineListProvider = StateNotifierProvider<WineListNotifier, AsyncValue<List<Wine>>>((ref) {
  return WineListNotifier();
});

