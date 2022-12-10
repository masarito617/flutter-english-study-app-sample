class GoogleApiSettings {
  // TODO この辺は各自設定してください
  static const String spreadsSheetsUrl = "";
  static const String sheetName = "";
  static const String apiKey = "";

  /// GoogleSheetsAPI(v4.spreadsheets.values - get)のURL生成
  /// 詳細: https://developers.google.com/sheets/api/reference/rest
  static String createGoogleSheetsApiGetUrl() {
    if (spreadsSheetsUrl.isEmpty || sheetName.isEmpty || apiKey.isEmpty) {
      throw ('please set google api settings.');
    }
    return 'https://sheets.googleapis.com/v4/spreadsheets/${spreadsSheetsUrl}/values/${sheetName}?key=${apiKey}';
  }
}
