import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/khatma_progress_entity.dart';

class KhatmaProvider extends StateNotifier<KhatmaProgressEntity> {
  final StorageService _storageService;

  KhatmaProvider(this._storageService) : super(KhatmaProgressEntity(
    highestPage: 0,
    totalPages: 604,
    startDate: DateTime.now(),
  )) {
    _loadKhatmaState();
  }

  Future<void> _loadKhatmaState() async {
    final highestPage = _storageService.khatmaHighestPage;
    final startDateStr = _storageService.khatmaStartDate;
    final completed = _storageService.khatmaCompleted;

    state = KhatmaProgressEntity(
      highestPage: highestPage,
      totalPages: 604,
      startDate: DateTime.parse(startDateStr),
      isCompleted: completed,
    );
  }

  Future<void> onPageRead(int page) async {
    final newHighestPage = page > state.highestPage ? page : state.highestPage;

    state = state.copyWith(highestPage: newHighestPage);

    if (page == 604) {
      state = state.copyWith(isCompleted: true);
      await _storageService.setKhatmaCompleted(true);
    } else if (state.isCompleted) {
      state = state.copyWith(isCompleted: false);
      await _storageService.setKhatmaCompleted(false);
    }

    await _storageService.setKhatmaHighestPage(state.highestPage);
  }

  Future<void> resetKhatma() async {
    state = KhatmaProgressEntity(
      highestPage: 0,
      totalPages: 604,
      startDate: DateTime.now(),
      isCompleted: false,
    );

    await _storageService.resetKhatma();
  }

  double get percentage => state.percentage;

  bool get isCompleted => state.isCompleted;
}

final khatmaProvider = StateNotifierProvider<KhatmaProvider, KhatmaProgressEntity>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return KhatmaProvider(storageService);
});
