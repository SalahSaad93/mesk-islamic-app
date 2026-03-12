import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/features/quran/data/datasources/reciter_datasource.dart';
import 'package:mesk_islamic_app/features/quran/domain/entities/reciter_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReciterDatasource Integration Tests', () {
    // We can't easily mock rootBundle in integration tests without some boilerplate,
    // but in Flutter test we can use `DefaultAssetBundle`.
    // Actually, we can just test the datasource if it takes the asset bundle.
    
    test('Loads reciters from JSON asset', () async {
      // In a real environment, this would use rootBundle.
      // For testing, we might need a mock or just rely on the actual asset if it exists in the test runner's context.
      final datasource = ReciterDatasource();
      final reciters = await datasource.getReciters();

      expect(reciters, isNotEmpty);
      expect(reciters.first, isA<ReciterEntity>());
      expect(reciters.any((r) => r.id == 'ar.alafasy'), true);
    });
  });
}
