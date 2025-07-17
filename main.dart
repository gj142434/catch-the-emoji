
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(CatchTheEmojiApp());

class CatchTheEmojiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catch the Emoji!',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: EmojiGame(),
    );
  }
}

class EmojiGame extends StatefulWidget {
  @override
  _EmojiGameState createState() => _EmojiGameState();
}

class _EmojiGameState extends State<EmojiGame> {
  final List<String> emojis = ['🤪', '👻', '🦄', '😺', '🐸', '🐵', '🤖', '🎃'];
  final List<String> decoys = ['💩', '😡', '👿'];
  final Random random = Random();
  Offset position = Offset(100, 100);
  String currentEmoji = '🤪';
  bool showEmoji = false;
  int round = 0;
  List<int> times = [];
  Stopwatch stopwatch = Stopwatch();

  void startGame() {
    setState(() {
      round = 0;
      times.clear();
      nextRound();
    });
  }

  void nextRound() {
    if (round >= 10) {
      showResults();
      return;
    }
    round++;
    final delay = Duration(milliseconds: 1000 + random.nextInt(2000));
    Timer(delay, () {
      setState(() {
        currentEmoji = random.nextBool()
            ? emojis[random.nextInt(emojis.length)]
            : decoys[random.nextInt(decoys.length)];
        position = Offset(
          50 + random.nextDouble() * 250,
          150 + random.nextDouble() * 400,
        );
        showEmoji = true;
      });
      stopwatch.reset();
      stopwatch.start();
    });
  }

  void tapEmoji() {
    if (!showEmoji) return;
    stopwatch.stop();
    final time = stopwatch.elapsedMilliseconds;
    setState(() {
      times.add(time);
      showEmoji = false;
    });
    nextRound();
  }

  void showResults() {
    final avg = (times.reduce((a, b) => a + b) / times.length).round();
    final minTime = times.reduce(min);
    final maxTime = times.reduce(max);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Game Over 🎉"),
        content: Text("Best: ${minTime}ms
Worst: ${maxTime}ms
Average: ${avg}ms"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: Text("Play Again"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Catch the Emoji!")),
      body: Stack(
        children: [
          if (showEmoji)
            Positioned(
              left: position.dx,
              top: position.dy,
              child: GestureDetector(
                onTap: tapEmoji,
                child: Text(
                  currentEmoji,
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: startGame,
                child: Text("Start Game"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
