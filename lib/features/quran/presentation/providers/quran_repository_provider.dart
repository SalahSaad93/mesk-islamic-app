import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/quran_user_data_datasource.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../data/services/quran_database_service.dart';
import '../../domain/repositories/quran_repository.dart';

final quranUserDataDatasourceProvider = Provider((ref) {
  final dbService = ref.watch(quranDbServiceProvider);
  return QuranUserDataDatasource(dbService);
});

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  final userDataDatasource = ref.watch(quranUserDataDatasourceProvider);
  return QuranRepositoryImpl(userDataDatasource);
});
