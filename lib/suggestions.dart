// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:jarvisplayer/apis/recipes_backend.dart';
import 'package:jarvisplayer/picovoicemanager.dart';
import 'package:jarvisplayer/recipe.dart';

class Suggestions extends StatefulWidget {
  const Suggestions({Key? key, required this.recipes}) : super(key: key);

  final List recipes;
  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
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
    print('dispose suggestions');
    _controller!.picovoiceManager?.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.recipes.length,
        itemBuilder: (context, index) => RecipeCard(
          controller: _controller,
          title: widget.recipes[index]['title'],
          imageUrl: widget.recipes[index]['image'],
          id: widget.recipes[index]['id'],
          recipes: widget.recipes,
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.id,
    required this.recipes,
    required this.controller,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final int id;
  final List recipes;
  final Picovoice? controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var recipe = await RecipesAPI().fetchRecipeDetails(id);
        // controller!.picovoiceManager?.stop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recipe(recipe: recipe),
          ),
        ).then((value) => {
          controller!.initPicovoice()
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image(
                    height: 70,
                    width: 70,
                    fit: BoxFit.fitHeight,
                    image: NetworkImage(imageUrl)),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title),
              )),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
