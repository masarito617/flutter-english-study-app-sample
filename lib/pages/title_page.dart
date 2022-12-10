import 'package:flutter/material.dart';
import 'select_word_page.dart';
import '../components/layout_widgets.dart';
import '../data/english_word_data.dart';

/// タイトル画面
class TitlePage extends StatefulWidget {
  const TitlePage({super.key});

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('えいすた！'),
        leading: Icon(
          Icons.book,
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            HalfScreenArea(
              child: Center(
                child: TitleTextAreaWidget(
                  errorMessage: _errorMessage,
                ),
              ),
            ),
            HalfScreenArea(
              child: Center(
                child: TitleButtonAreaWidget(
                  isOptionShuffle: _isOptionShuffle,
                  onChangedOptionShuffleCheckBox:
                      onChangedOptionShuffleCheckBox,
                  onPressedStartButton: onPressedStartButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isOptionShuffle = false; // シャッフルするか？
  String _errorMessage = ""; // エラーメッセージ
  bool _isDoProcess = false; // 処理中か？

  /// シャッフルチェックボックス切替時
  void onChangedOptionShuffleCheckBox(bool isOn) {
    setState(() {
      _isOptionShuffle = isOn;
    });
  }

  /// STARTボタン押下時
  void onPressedStartButton() async {
    if (_isDoProcess) return;
    _isDoProcess = true;
    setState(() => _errorMessage = "");

    // データ取得
    var englishWordDataList =
        await EnglishWordDataRepository.getEnglishWordDataListFromApi();
    if (englishWordDataList.isEmpty) {
      setState(() => _errorMessage = "データが取得できません");
      _isDoProcess = false;
      return;
    }

    // データを渡してページ遷移
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectWordPage(
          englishWordDataList: englishWordDataList,
          isOptionShuffle: _isOptionShuffle,
        ),
      ),
    );

    _isDoProcess = false;
  }
}

/// タイトルテキストエリア
class TitleTextAreaWidget extends StatelessWidget {
  final String errorMessage; // エラーメッセージ
  const TitleTextAreaWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // タイトル
        const Text(
          'Let\'s English!!',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 20),
        // エラーメッセージ
        SizedBox(
          height: 28,
          child: Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

/// タイトルボタンエリア
class TitleButtonAreaWidget extends StatelessWidget {
  final bool isOptionShuffle;
  final Function onChangedOptionShuffleCheckBox;
  final Function onPressedStartButton;
  const TitleButtonAreaWidget(
      {super.key,
      required this.isOptionShuffle,
      required this.onChangedOptionShuffleCheckBox,
      required this.onPressedStartButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // シャッフルオプション
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: isOptionShuffle,
              onChanged: (isOn) => onChangedOptionShuffleCheckBox(isOn),
            ),
            const Text(
              '問題をシャッフルする',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // STARTボタン
        SizedBox(
          width: 120,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              foregroundColor: Theme.of(context).backgroundColor,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () => onPressedStartButton(),
            child: const Text('START'),
          ),
        ),
      ],
    );
  }
}
