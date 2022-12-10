import 'package:flutter/material.dart';
import '../components/layout_widgets.dart';
import '../data/english_word_data.dart';

/// 問題の表示状態
enum QuestionDisplayState {
  none,
  ok,
  ng,
  result,
}

/// 単語選択画面
class SelectWordPage extends StatefulWidget {
  final List<EnglishWordData> englishWordDataList;
  final bool isOptionShuffle;
  const SelectWordPage(
      {super.key,
      required this.englishWordDataList,
      required this.isOptionShuffle});

  @override
  State<SelectWordPage> createState() => _SelectWordPageState();
}

class _SelectWordPageState extends State<SelectWordPage> {
  // 英単語データリスト
  List<EnglishWordData> _englishWordDataList = [];
  // 問題の表示状態
  QuestionDisplayState _questionDisplayState = QuestionDisplayState.none;
  // 問題データ
  EnglishWordData? _questionWordData;
  int _questionIndex = 0;
  int _okAnswerCount = 0;
  // 選択単語リスト
  List<String> _selectWordList = [];
  // 選択単語数
  static const int selectWordCount = 4;

  @override
  void initState() {
    super.initState();
    // 遷移元からデータを受け取る
    _englishWordDataList = widget.englishWordDataList;
    // オプション指定されていたらシャッフルする
    if (widget.isOptionShuffle) {
      _englishWordDataList.shuffle();
    }
    // 最初の問題を生成
    _questionIndex = 0;
    _okAnswerCount = 0;
    createQuestion(_questionIndex);
  }

  /// 問題の生成
  void createQuestion(int index) {
    _questionDisplayState = QuestionDisplayState.none;
    _questionWordData = _englishWordDataList[index];
    _selectWordList =
        createRandomSelectWordList(_questionWordData?.japaneseWord ?? 'empty');
  }

  /// 単語選択リスト生成
  List<String> createRandomSelectWordList(String answer) {
    // 単語データをコピー
    var copyEnglishWordDataList = List.of(_englishWordDataList);
    copyEnglishWordDataList.shuffle();
    // 選択する単語リストを生成
    List<String> selectWordList = [];
    selectWordList.add(answer);
    for (var i = 0; i < copyEnglishWordDataList.length; i++) {
      var japaneseWord = copyEnglishWordDataList[i].japaneseWord;
      // 答えとなる日本語は除く
      if (answer == japaneseWord) {
        continue;
      }
      // 指定数設定したら抜ける
      selectWordList.add(japaneseWord);
      if (selectWordList.length >= selectWordCount) {
        break;
      }
    }
    selectWordList.shuffle();
    return selectWordList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: displaySelectWordPageWidgetList(),
        ),
      ),
    );
  }

  List<Widget> displaySelectWordPageWidgetList() {
    // 結果表示
    if (_questionDisplayState == QuestionDisplayState.result) {
      return [
        SelectWordResultAreaWidget(
          totalIndex: _englishWordDataList.length,
          correctCount: _okAnswerCount,
        ),
      ];
    }
    // 問題表示
    return [
      HalfScreenArea(
        child: SelectWordQuestionAreaWidget(
          question: _questionWordData?.englishWord ?? 'empty',
          answer: _questionWordData?.japaneseWord ?? 'empty',
          index: _questionIndex + 1,
          totalIndex: _englishWordDataList.length,
          questionDisplayState: _questionDisplayState,
        ),
      ),
      HalfScreenArea(
        child: SelectWordButtonsAreaWidget(
          selectWordList: _selectWordList,
          onPressedSelectWordButton: onPressedSelectWordButton,
          isShowNext: _questionDisplayState == QuestionDisplayState.ok ||
              _questionDisplayState == QuestionDisplayState.ng,
          onPressedNextButton: onPressedNextButton,
        ),
      ),
    ];
  }

  /// 単語ボタン押下処理
  void onPressedSelectWordButton(String selectWord) {
    // 答え合わせ
    setState(() {
      var isCorrect = selectWord == _questionWordData?.japaneseWord;
      if (isCorrect) _okAnswerCount++;
      _questionDisplayState =
          isCorrect ? QuestionDisplayState.ok : QuestionDisplayState.ng;
    });
  }

  /// NEXTボタン押下処理
  void onPressedNextButton() {
    setState(() {
      // 最後まで問題を出したら結果表示
      _questionIndex++;
      if (_englishWordDataList.length <= _questionIndex) {
        _questionDisplayState = QuestionDisplayState.result;
        return;
      }
      // 次の問題を表示
      createQuestion(_questionIndex);
    });
  }
}

/// 問題文エリア
class SelectWordQuestionAreaWidget extends StatelessWidget {
  final String question;
  final String answer;
  final int index;
  final int totalIndex;
  final QuestionDisplayState questionDisplayState;
  const SelectWordQuestionAreaWidget(
      {super.key,
      required this.question,
      required this.answer,
      required this.index,
      required this.totalIndex,
      required this.questionDisplayState});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 問題数
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '$index / $totalIndex',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // 問題文
              Text(
                question,
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              // 結果表示
              getAnsewerWordTextWidget(answer, questionDisplayState),
              const SizedBox(height: 32),
              getAnsewerResultTextWidget(questionDisplayState),
            ],
          ),
        ),
      ],
    );
  }

  Widget getAnsewerWordTextWidget(String answer, QuestionDisplayState state) {
    var color = Colors.white;
    if (state == QuestionDisplayState.none) {
      color = color.withOpacity(0.0);
    }
    return Text(
      answer,
      style: TextStyle(
        fontSize: 18,
        color: color,
      ),
    );
  }

  Widget getAnsewerResultTextWidget(QuestionDisplayState state) {
    var message = "";
    var color = Colors.black;
    switch (state) {
      case QuestionDisplayState.ok:
        message = "○";
        color = Colors.red;
        break;
      case QuestionDisplayState.ng:
        message = "×";
        color = Colors.blue;
        break;
      case QuestionDisplayState.none:
      case QuestionDisplayState.result:
        break;
    }
    return SizedBox(
      height: 42, // 文字の内容に限らず高さを固定
      child: Text(
        message,
        style: TextStyle(
          fontSize: 32,
          color: color,
        ),
      ),
    );
  }
}

/// 単語選択ボタンエリア
class SelectWordButtonsAreaWidget extends StatelessWidget {
  final List<String> selectWordList;
  final Function onPressedSelectWordButton;
  final bool isShowNext;
  final Function onPressedNextButton;
  const SelectWordButtonsAreaWidget(
      {super.key,
      required this.selectWordList,
      required this.onPressedSelectWordButton,
      required this.isShowNext,
      required this.onPressedNextButton});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // 単語選択ボタン群
      Expanded(
        flex: 5,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          padding: const EdgeInsets.all(50.0),
          childAspectRatio: 2.5,
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          children: selectWordList
              .map((selectWord) => SelectWordButtonWidget(
                    text: selectWord,
                    onPressed: isShowNext ? null : onPressedSelectWordButton,
                  ))
              .toList(),
        ),
      ),
      // NEXTボタン
      if (isShowNext)
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 48),
              child: TextButton(
                onPressed: () => onPressedNextButton(),
                child: Text(
                  'NEXT ▶︎',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}

/// 単語選択ボタン
class SelectWordButtonWidget extends StatelessWidget {
  final String text;
  final Function? onPressed;
  const SelectWordButtonWidget(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 14),
        foregroundColor: Theme.of(context).backgroundColor,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: onPressed == null ? null : () => onPressed!(text),
      child: Text(text),
    );
  }
}

/// 結果表示
class SelectWordResultAreaWidget extends StatelessWidget {
  final int totalIndex;
  final int correctCount;
  const SelectWordResultAreaWidget(
      {super.key, required this.totalIndex, required this.correctCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '正解数: $correctCount / $totalIndex',
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 120,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                foregroundColor: Theme.of(context).backgroundColor,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('BACK'),
            ),
          ),
        ],
      ),
    );
  }
}
