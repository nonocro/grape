
import 'package:riverpod/riverpod.dart';
import '../models/wine.dart';
import '../services/wine.dart';

final wineListProvider = FutureProvider<List<Wine>>((ref) async {
  return fetchRedWines();
});

