import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/reciter_datasource.dart';
import '../../domain/entities/reciter_entity.dart';

final reciterDatasourceProvider = Provider((ref) => ReciterDatasource());

final recitersProvider = FutureProvider<List<ReciterEntity>>((ref) async {
  return ref.read(reciterDatasourceProvider).getReciters();
});

final selectedReciterProvider = StateProvider<ReciterEntity?>((ref) => null);
