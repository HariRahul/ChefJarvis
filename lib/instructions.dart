// ignore_for_file: avoid_unnecessary_containers, prefer_typing_uninitialized_variables, must_be_immutable
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:jarvisplayer/picovoicemanager.dart';
import 'package:jarvisplayer/providers/instructions_state.dart';
import 'package:picovoice/picovoice_manager.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Instructions extends StatefulWidget {
  const Instructions(
      {Key? key, required this.instructions, required this.website})
      : super(key: key);

  final List instructions;
  final String website;
  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  Picovoice? _controller;
  WebViewController? _webcontroller;
  var instructionModel;

  @override
  void initState() {
    super.initState();
    _controller = Picovoice(context, 'Instructions');
    _controller!.initPicovoice();
  }

  @override
  void dispose() async {
    super.dispose();
    print('dispose instructions');
    _controller!.picovoiceManager?.stop();
    instructionModel.setStep(0);
  }

  @override
  Widget build(BuildContext context) {
    instructionModel = Provider.of<InstructionState>(context);
    _controller!.setModel(instructionModel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
      ),
      body: Container(
        child: Center(
          child: widget.instructions.isEmpty
              ? WebView(
                  initialUrl: widget.website,
                  onWebViewCreated: (WebViewController webViewController) {
                    _webcontroller = webViewController;
                    _controller!.setController(_webcontroller);
                  },
                )
              : InstructionCard(
                  voiceController: _controller,
                  instructionModel: instructionModel,
                  index: instructionModel.getStep(),
                  text: widget.instructions[instructionModel.getStep()]
                      .toString(),
                ),
        ),
      ),
    );
  }
}

class InstructionCard extends StatefulWidget {
  InstructionCard(
      {Key? key,
      required this.index,
      required this.text,
      this.instructionModel,
      required this.voiceController})
      : super(key: key);
  final int index;
  final String text;
  var instructionModel;
  final Picovoice? voiceController;

  @override
  State<InstructionCard> createState() => _InstructionCardState();
}

class _InstructionCardState extends State<InstructionCard> {
  ScrollController? scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.voiceController!.setScrollController(scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    widget.instructionModel.decrementStep();
                  },
                  child: const Text('Previous'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.index.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    widget.instructionModel.incrementStep();
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            widget.text,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
