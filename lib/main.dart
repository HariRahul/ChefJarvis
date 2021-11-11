import 'package:flutter/material.dart';
import 'package:jarvisplayer/picovoicemanager.dart';
import 'package:jarvisplayer/providers/instructions_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InstructionState>(
      create: (context) => InstructionState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Picovoice? _controller;

  @override
  void initState() {
    super.initState();
    _controller = Picovoice(context, 'Recipe');
    _controller!.initPicovoice();
  }

  @override
  void dispose() async {
    super.dispose();
    print('dispose main');
    _controller!.picovoiceManager?.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chef Jarvis'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/Voice control.gif'),
              fit: BoxFit.fitWidth),
        ),
      ),
    );
  }
}
