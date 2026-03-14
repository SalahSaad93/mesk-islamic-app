import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/quran_tafsir_datasource.dart';
import '../../data/services/quran_database_service.dart';
import '../../domain/entities/tafsir_entity.dart';

final quranTafsirDatasourceProvider = Provider<QuranTafsirDatasource>((ref) {
  final dbService = ref.watch(quranDbServiceProvider);
  return QuranTafsirDatasource(dbService);
});

final tafsirProvider = FutureProvider.family<TafsirEntity?, int>((ref, verseId) async {
  final datasource = ref.watch(quranTafsirDatasourceProvider);
  return await datasource.getTafsir(verseId, 'en-tafisr-ibn-kathir');
});

final selectedTafsirSourceProvider = StateProvider<String>((ref) => 'en-tafisr-ibn-kathir');
