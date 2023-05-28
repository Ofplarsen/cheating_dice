import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey
      ),
      home: const MyDice(title: 'Dice'),
    );
  }
}

class MyDice extends StatefulWidget {
  const MyDice({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyDice> createState() => _MyDiceState();
}

class _MyDiceState extends State<MyDice> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = IntTween(begin: 0, end: 4).animate(_controller)
      ..addListener(() {
        setState(() {
          int i = _imageIndex;
          i += _rollDice();
          _imageIndex = i % 5;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isAnimating = false;
        }
      });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _random = Random();
  int _imageIndex = 0;
  final List<String> images = ["one", "two", "three", "four", "five", "six"];

  int _rollDice(){
    return _random.nextInt(6);
  }

  Future _doAnimation() async{
    if (_isAnimating) {
      return;
    }
    _isAnimating = true;
    _controller.reset();
    await _controller.forward().orCancel;
  }

  void _cheat() async {
    await _doAnimation();

    setState(() {
      _imageIndex = 5;
    });
  }

  void _getOne() async{
    await _doAnimation();

    setState(() {
      _imageIndex = 0;
    });
  }

  void _changeImage() async {
    await _doAnimation();

    setState(() {
      _imageIndex = _rollDice();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _changeImage,
        onDoubleTap: _getOne,
        onLongPress: _cheat,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/${images[_imageIndex]}.png",
                height: 200,
                width: 200,
                fit: BoxFit.fitWidth,
                gaplessPlayback: true,
              ),
              Text(
                'Dice: ${_imageIndex + 1}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
