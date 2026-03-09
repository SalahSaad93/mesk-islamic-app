import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/athkar_local_datasource.dart';
import '../../domain/entities/thikr_entity.dart';

final athkarDatasourceProvider = Provider((_) => AthkarLocalDatasource());

final morningAthkarProvider = FutureProvider<List<ThikrEntity>>((ref) async {
  return ref.read(athkarDatasourceProvider).getMorningAthkar();
});

final eveningAthkarProvider = FutureProvider<List<ThikrEntity>>((ref) async {
  return ref.read(athkarDatasourceProvider).getEveningAthkar();
});

// Tracks remaining count per thikr id
class AthkarProgressNotifier extends StateNotifier<Map<int, int>> {
  AthkarProgressNotifier() : super({});

  void initProgress(List<ThikrEntity> athkar) {
    if (state.isEmpty) {
      state = {for (final t in athkar) t.id: t.repeatCount};
    }
  }

  void decrement(int thikrId) {
    final current = state[thikrId] ?? 0;
    if (current > 0) {
      state = {...state, thikrId: current - 1};
    }
  }

  void reset(List<ThikrEntity> athkar) {
    state = {for (final t in athkar) t.id: t.repeatCount};
  }

  bool isDone(int thikrId) => (state[thikrId] ?? 1) == 0;
  int remaining(int thikrId, int total) => state[thikrId] ?? total;
}

final morningProgressProvider =
    StateNotifierProvider<AthkarProgressNotifier, Map<int, int>>(
  (_) => AthkarProgressNotifier(),
);

final eveningProgressProvider =
    StateNotifierProvider<AthkarProgressNotifier, Map<int, int>>(
  (_) => AthkarProgressNotifier(),
);
