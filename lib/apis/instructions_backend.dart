// ignore_for_file: unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvisplayer/constants.dart';

class InstructionsAPI {

  fetchInstructions(recipeID) async {
    var request = http.Request(
      'GET',
      Uri.parse(
          'https://api.spoonacular.com/recipes/'+recipeID.toString()+'/analyzedInstructions?apiKey='+apiKey));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString =  await (response.stream.bytesToString());
      if (jsonDecode(responseString) == []){
        return [];
      }
      else{
        var instructionsList = [];
        for (var i=0;i<jsonDecode(responseString).length;i++){
          for (var j=0;j<jsonDecode(responseString)[i]['steps'].length;j++){
            instructionsList.add(jsonDecode(responseString)[i]['steps'][j]['step']);
          }
        }
        return instructionsList;
      }
    } else {
      return [];
    }
  }
}
