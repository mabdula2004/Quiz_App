import 'package:flutter/material.dart';
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int trueCount = 0;
  int falseCount = 0;

  List<Color> questionTextColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];
  int currentColorIndex = 0;

  void checkAnswer(bool userPickedAnswer) {
    bool? correctAnswer = quizBrain.getCorrectAnswer();

    setState(() {
      if (quizBrain.isFinished()) {
        showAlert(context, 'Finished!', 'You\'ve reached the end of the quiz.');

        quizBrain.reset();
        scoreKeeper = [];
        trueCount = 0;
        falseCount = 0;
        currentColorIndex = 0;
      } else {
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(
            Icon(
              Icons.check,
              color: Colors.green,
            ),
          );
          trueCount++;
        } else {
          scoreKeeper.add(
            Icon(
              Icons.close,
              color: Colors.red,
            ),
          );
          falseCount++;
        }
        quizBrain.nextQuestion();
        currentColorIndex = (currentColorIndex + 1) % questionTextColors.length;
      }
    });
  }

  void resetQuiz() {
    setState(() {
      quizBrain.reset();
      scoreKeeper = [];
      trueCount = 0;
      falseCount = 0;
      currentColorIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              'True: $trueCount | False: $falseCount',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText() ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: questionTextColors[currentColorIndex],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // The user picked true.
                checkAnswer(true);
              },
              child: Text(
                'True',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                // The user picked false.
                checkAnswer(false);
              },
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: resetQuiz,
            child: Text(
              'Reset Quiz',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showAlert(BuildContext context, String title, String desc) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(desc),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
