// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:jarvisplayer/apis/instructions_backend.dart';
import 'package:jarvisplayer/instructions.dart';
import 'package:jarvisplayer/picovoicemanager.dart';
import 'package:jarvisplayer/providers/instructions_state.dart';
import 'package:provider/provider.dart';

class Recipe extends StatefulWidget {
  const Recipe({Key? key, required this.recipe}) : super(key: key);

  final Map recipe;
  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  Picovoice? _controller;
  ListView? ingredientsList;

  @override
  void initState() {
    super.initState();
    _controller = Picovoice(context, 'Recipe');
    _controller!.initPicovoice();
    ingredientsList = ListView.builder(
      itemCount: widget.recipe['extendedIngredients'].length,
      itemBuilder: (context, index) => Expanded(
        child: Row(
          children: [
            Text(widget.recipe['extendedIngredients'][index]['OriginalString']
                .toString()),
            Text(widget.recipe['extendedIngredients'][index]['amount']
                .toString()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    print('dispose recipe');
    _controller!.picovoiceManager?.stop();
  }

  @override
  Widget build(BuildContext context) {
    final instructionModel = Provider.of<InstructionState>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.play_arrow_rounded),
          onPressed: () async {
            List instructionsList = await InstructionsAPI().fetchInstructions(widget.recipe['id']);
            String instructionWebsite = widget.recipe['sourceUrl'];

            if (instructionsList.isEmpty) {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Instructions(
                    instructions: const [],
                    website: instructionWebsite,
                  ),
                ),
              ).then((value) => _controller!.initPicovoice());
            } else {
              instructionModel.setmaxSteps(instructionsList.length - 1);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Instructions(
                    instructions: instructionsList,
                    website: '',
                  ),
                ),
              ).then((value) => _controller!.initPicovoice());
            }
          }),
      appBar: AppBar(),
      body: Container(
        child: RecipeDetails(
          ingredients: widget.recipe['extendedIngredients'],
          title: widget.recipe['title'],
          duration: widget.recipe['readyInMinutes'],
          servings: widget.recipe['servings'],
          image: widget.recipe['image'],
        ),
      ),
    );
  }
}

class RecipeDetails extends StatelessWidget {
  const RecipeDetails(
      {Key? key,
      required this.ingredients,
      required this.title,
      required this.duration,
      required this.servings,
      required this.image})
      : super(key: key);

  final List ingredients;
  final String title;
  final int duration;
  final int servings;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Recipe name
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        //Image and details
        Row(
          children: [
            //Image
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.fill),
                ),
              ),
            ),
            //Duration and servings
            Column(
              children: [
                //Duration
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.timelapse_sharp),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(duration.toString() + ' minutes'),
                    ),
                  ],
                ),
                //Servings
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.food_bank_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(servings.toString() + ' servings'),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        //Ingredients title
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Ingredients:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),

        //Ingredients list
        Container(
          height: 300,
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) => Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text(ingredients[index]['originalString'].toString()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ingredients[index]['amount'].toString() + ' ' +ingredients[index]['unit']),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
