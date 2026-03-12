import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/datasources/athkar_local_datasource.dart';
import '../../domain/entities/thikr_entity.dart';

final athkarDatasourceProvider = Provider((_) => AthkarLocalDatasource());

final athkarByCategoryProvider =
    FutureProvider.family<List<ThikrEntity>, String>((ref, category) async {
      return ref.read(athkarDatasourceProvider).getAthkarByCategory(category);
    });

/// Persists per-category athkar progress and resets daily.
/// Morning resets after midnight; evening resets after noon.
class AthkarProgressNotifier extends StateNotifier<Map<int, int>> {
  final StorageService _storage;
  final String _category;

  AthkarProgressNotifier(this._storage, this._category) : super({}) {
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final now = DateTime.now();
    final lastResetStr = _storage.getAthkarLastReset(_category);

    // Determine reset boundary
    final shouldReset = _shouldResetToday(lastResetStr, now);

    if (shouldReset) {
      // Will be populated fresh in initProgress
      state = {};
    } else {
      final saved = _storage.getAthkarProgress(_category);
      if (saved != null) {
        try {
          final Map<String, dynamic> map = json.decode(saved);
          state = map.map((k, v) => MapEntry(int.parse(k), v as int));
          return;
        } catch (_) {}
      }
      state = {};
    }
  }

  bool _shouldResetToday(String? lastResetStr, DateTime now) {
    if (lastResetStr == null) return false;
    try {
      final lastReset = DateTime.parse(lastResetStr);
      // Reset boundary: morning before noon, evening before midnight
      final boundary = _category == 'morning' || _category == 'after_fajr'
          ? DateTime(now.year, now.month, now.day, 12, 0) // noon
          : DateTime(now.year, now.month, now.day, 0, 0); // midnight

      // If last reset was before today's boundary and we're past the boundary
      return lastReset.isBefore(boundary) && now.isAfter(boundary);
    } catch (_) {
      return false;
    }
  }

  void initProgress(List<ThikrEntity> athkar) {
    // Only init if state is empty (fresh or reset)
    if (state.isEmpty) {
      state = {for (final t in athkar) t.id: t.repeatCount};
      _persist();
    }
  }

  void decrement(int thikrId) {
    final current = state[thikrId] ?? 0;
    if (current > 0) {
      state = {...state, thikrId: current - 1};
      _persist();
    }
  }

  void reset(List<ThikrEntity> athkar) {
    state = {for (final t in athkar) t.id: t.repeatCount};
    _storage.setAthkarLastReset(_category, DateTime.now().toIso8601String());
    _persist();
  }

  void _persist() {
    final encoded = json.encode(state.map((k, v) => MapEntry(k.toString(), v)));
    _storage.saveAthkarProgress(_category, encoded);
  }

  bool isDone(int thikrId) => (state[thikrId] ?? 1) == 0;
  int remaining(int thikrId, int total) => state[thikrId] ?? total;

  bool get isAllDone => state.isNotEmpty && state.values.every((v) => v == 0);
}

final athkarProgressProvider =
    StateNotifierProvider.family<AthkarProgressNotifier, Map<int, int>, String>(
      (ref, category) {
        final storage = ref.watch(storageServiceProvider);
        return AthkarProgressNotifier(storage, category);
      },
    );

final athkarCompletionProvider = Provider.family<bool, String>((ref, category) {
  final progress = ref.watch(athkarProgressProvider(category));
  return progress.isNotEmpty && progress.values.every((v) => v == 0);
});
