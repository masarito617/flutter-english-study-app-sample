import 'dart:convert';
import 'package:http/http.dart' as http;
import '../settings/googleapi_settings.dart';

/// 英単語データ
class EnglishWordData {
  EnglishWordData({required this.englishWord, required this.japaneseWord});
  final String englishWord; // 英単語
  final String japaneseWord; // 日本語
}

/// 英単語データリポジトリ
class EnglishWordDataRepository {
  /// APIからのデータ取得
  static Future<List<EnglishWordData>> getEnglishWordDataListFromApi() async {
    final List<EnglishWordData> result = [];
    try {
      // レスポンス取得
      final url = GoogleApiSettings.createGoogleSheetsApiGetUrl();
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw ('Failed to Load English Word Data.');
      }
      // 中身のチェック
      final Map<String, dynamic> message = json.decode(res.body);
      if (message['values'] == null) {
        throw ('Please Set English Word Data.');
      }
      // 英単語データとして変換
      final List<dynamic> values = message['values'];
      values.forEach((value) => {
            result.add(
                EnglishWordData(englishWord: value[0], japaneseWord: value[1]))
          });
    } catch (e) {
      print(e); // エラーはログに出力して握りつぶす
    }
    return result;
  }
}
