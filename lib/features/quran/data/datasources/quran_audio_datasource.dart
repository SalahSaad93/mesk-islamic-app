
class QuranAudioDatasource {
  /// Gets the verse URL.
  /// Depending on the reciter's audioBaseUrl, the format might change.
  /// Islamic.network verse URLs: [audioBaseUrl]/[verse_id].mp3
  /// Note: verse_id usually starts from 1 (Al-Fatiha 1).
  String getVerseAudioUrl(String baseUrl, int surah, int ayah) {
    // This is a simplified version. Some providers use surah-ayah padding.
    // If it's everyayah.com style:
    if (baseUrl.contains('everyayah.com')) {
      final surahStr = surah.toString().padLeft(3, '0');
      final ayahStr = ayah.toString().padLeft(3, '0');
      return '${baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'}$surahStr$ayahStr.mp3';
    }
    
    // Defaulting to a simple concatenation (needs actual logic per provider if inconsistent)
    // For many providers, it's just index.mp3 or surah/ayah.mp3
    return '${baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'}$surah/$ayah.mp3';
  }
}
