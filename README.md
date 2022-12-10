# 英単語学習アプリ

* Googleスプレッドシートと連携した英単語学習アプリです。
* タイトル画面、単語選択画面を行き来する構成になっています。
<div style="display: flex;">
<img width="200" alt="ScreenShot 2022-12-10 23 01 33" src="https://user-images.githubusercontent.com/77447256/206859286-53bcca57-fffb-4855-9d27-f29edd60ffe9.png">
<img width="200" alt="ScreenShot 2022-12-10 23 02 06" src="https://user-images.githubusercontent.com/77447256/206859290-70e7642e-cf3f-4688-859a-7f18060a904d.png">
</div>

* Google Sheets API を使用して英単語データを取得するようにしています。<br><code>lib/settings/google_api_settings.dart</code>にスプレッドシートID、シート名、APIキーを設定して使用してください。<br><a href="https://developers.google.com/sheets/api/reference/rest">Google Sheets API 仕様詳細</a>

```
　　　　// この辺は各自設定してください
　　　　static const String spreadsSheetsUrl =　"";
　　　　static const String sheetName = "";
　　　　static const String apiKey = "";
```
