import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/tasbih_session.dart';

class TasbihState {
  final int count;
  final int target;
  final int selectedDhikrIndex;
  final List<TasbihSession> sessions;

  const TasbihState({
    this.count = 0,
    this.target = 33,
    this.selectedDhikrIndex = 0,
    this.sessions = const [],
  });

  TasbihState copyWith({
    int? count,
    int? target,
    int? selectedDhikrIndex,
    List<TasbihSession>? sessions,
  }) => TasbihState(
    count: count ?? this.count,
    target: target ?? this.target,
    selectedDhikrIndex: selectedDhikrIndex ?? this.selectedDhikrIndex,
    sessions: sessions ?? this.sessions,
  );
}

class TasbihNotifier extends Notifier<TasbihState> {
  late StorageService _storage;

  @override
  TasbihState build() {
    _storage = ref.watch(storageServiceProvider);
    return TasbihState(sessions: _loadSessions());
  }

  List<TasbihSession> _loadSessions() {
    final json = _storage.getTasbihSessions();
    if (json == null || json.isEmpty) return [];
    try {
      return TasbihSession.listFromJson(json);
    } catch (_) {
      return [];
    }
  }

  void increment() {
    if (state.count < state.target) {
      state = state.copyWith(count: state.count + 1);
    }
  }

  void reset() {
    state = state.copyWith(count: 0);
  }

  void selectDhikr(int index, int newTarget) {
    state = state.copyWith(
      selectedDhikrIndex: index,
      target: newTarget,
      count: 0,
    );
  }

  void saveSession({required String arabic, required String transliteration}) {
    if (state.count == 0) return;
    final session = TasbihSession(
      arabic: arabic,
      transliteration: transliteration,
      count: state.count,
      target: state.target,
      timestamp: DateTime.now(),
    );
    final updated = [session, ...state.sessions];
    // Keep max 50 sessions
    final capped = updated.length > 50 ? updated.sublist(0, 50) : updated;
    _storage.saveTasbihSessions(TasbihSession.listToJson(capped));
    state = state.copyWith(sessions: capped, count: 0);
  }
}

final tasbihProvider = NotifierProvider<TasbihNotifier, TasbihState>(
  TasbihNotifier.new,
);
