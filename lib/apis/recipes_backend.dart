// ignore_for_file: unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvisplayer/constants.dart';

class RecipesAPI {

  fetchRecipesList(ingredients) async {
    var request = http.Request(
      'GET',
      Uri.parse(
          'https://api.spoonacular.com/recipes/findByIngredients?ingredients='+ingredients.join(',')+'&number=10&apiKey='+apiKey));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString =  await (response.stream.bytesToString());
      return jsonDecode(responseString);
    } else {
      return [];
    }
  }

  fetchRecipeDetails(recipeID) async {
    var request = http.Request(
      'GET',
      Uri.parse(
          'https://api.spoonacular.com/recipes/'+recipeID.toString()+'/information?includeNutrition=false&apiKey='+apiKey));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString =  await (response.stream.bytesToString());
      return jsonDecode(responseString);
    } else {
      return [];
    }
  }
}
