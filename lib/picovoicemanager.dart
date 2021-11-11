// ignore_for_file: avoid_print
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvisplayer/apis/recipes_backend.dart';
import 'package:jarvisplayer/suggestions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picovoice/picovoice_manager.dart';
import 'package:picovoice/picovoice_error.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Picovoice {
  dynamic context;
  String? page;
  dynamic instructionModel;
  WebViewController? webController;
  ScrollController? scrollController;

  @override
  Picovoice(pageContext, pageName) {
    context = pageContext;
    page = pageName;
  }

  PicovoiceManager? picovoiceManager;

  void setModel(model) {
    instructionModel = model;
  }

  void setController(controller) {
    webController = controller;
  }

  void setScrollController(controller) {
    scrollController = controller;
  }

  void initPicovoice() async {
    String keywordAsset = "assets/jarvis_android.ppn";
    String keywordPath = await extractAsset(keywordAsset);
    String contextAsset = "assets/jarvis_android_rhino.rhn";
    String contextPath = await extractAsset(contextAsset);

    try {
      picovoiceManager = await PicovoiceManager.create(
          keywordPath, wakeWordCallback, contextPath, inferenceCallback);
      picovoiceManager?.start();
    } on PvError catch (ex) {
      print(ex);
    }
  }

  void wakeWordCallback() async {
    print("wake word detected!");
    final player = AudioCache();
    await player.play('notification_sound_sys.mp3');
  }

  void inferenceCallback(Map<String, dynamic> inference) async {
    print(inference);

    if (inference['intent'] == 'recipe') {
      Map<String, dynamic> slots = inference['slots'];

      var ingredientsList = [];
      for (var e in slots.entries) {
        ingredientsList.add(e.value);
      }

      var recipesList = await RecipesAPI().fetchRecipesList(ingredientsList);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  Suggestions(recipes: recipesList)),
          (Route<dynamic> route) => false).then((value) => {initPicovoice()});
    } else if ((inference['intent'] == 'next' ||
            inference['intent'] == 'previous' ||
            inference['intent'] == 'up' ||
            inference['intent'] == 'down') &&
        page == 'Instructions') {
      if (inference['intent'] == 'previous') {
        instructionModel.decrementStep();
      } else if (inference['intent'] == 'next') {
        instructionModel.incrementStep();
      } else if (inference['intent'] == 'up') {
        if (scrollController == null) {
          webController!.scrollBy(0, -1500);
        } else {
          scrollController!.animateTo(scrollController!.offset - 250,
              duration: const Duration(seconds: 1), curve: Curves.easeIn);
        }
      } else if (inference['intent'] == 'down') {
        if (scrollController == null) {
          webController!.scrollBy(0, 1500);
        } else {
          scrollController!.animateTo(scrollController!.offset + 250,
              duration: const Duration(seconds: 1), curve: Curves.easeIn);
        }
      }
    } else {
      //Do nothing
    }
  }

  Future<String> extractAsset(String resourcePath) async {
    String resourceDirectory = (await getApplicationDocumentsDirectory()).path;
    String outputPath = '$resourceDirectory/$resourcePath';
    File outputFile = File(outputPath);

    ByteData data = await rootBundle.load(resourcePath);
    final buffer = data.buffer;

    await outputFile.create(recursive: true);
    await outputFile.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return outputPath;
  }
}
