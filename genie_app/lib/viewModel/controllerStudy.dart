import 'dart:convert';

import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ControllerStudy {

  static Future<String> addNewFlashCard(String term, String def, String topicID)async{
    try {

      Flashcard flashcard = Flashcard(term, def);
      await Connection.addNewFlashCard(flashcard, topicID);
      

      return 'success';
    } catch (e) {
      print(e);
      return 'error';
    }
  }

    static Future<List<Flashcard>> getFlashcards(String topicID)async{
    try {

      return await Connection.getFlashCards(topicID);
      
    } catch (e) {
      return [];
    }
  }

    static Future <String> updateFlashcard(Flashcard newFlashcard, String id)async{
        try {

          return await Connection.updateFlashcard(newFlashcard, id);
          
        } catch (e) {
          return 'error';
        }
      }
    static Future <String> deleteFlashcard(String flashcardId, String topicId, int i)async{
        try {

          return await Connection.deleteFlashcard(flashcardId, topicId, i);
          
        } catch (e) {
          return 'error';
        }
      }

    static Future<User> getUserFromInfo()async{
      final prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("user");
    User loggedUser;
    if (user != null) {
      loggedUser = User.fromShared(jsonDecode(user));
      return loggedUser;
    } else {
      return User("", "");
    }
    }

    static Future<List<bool>> checkIfStudied(String topicID, List<Flashcard> flashcards)async{
      try {
        User user = await Controller.getUserInfo();
       print(user.toJson());
      User fullUser = await Connection.getUser(user.id);
      List<bool> studiedFlash=[];
      for (var element in fullUser.flashCardsStudied) {
        if(element['topic']==topicID){
          List<dynamic> studied = element["studied"]?? [];
          for(var el in flashcards){
              if(studied.indexWhere((e)=> e== el.id)!=-1){
                studiedFlash.add(true);
              }else{
                studiedFlash.add(false);
              }
          }
        } 
      }
       return studiedFlash; 
      } catch (e) {
        return [];
      }
       

      
     
    }

    static Future updateStudied(List<bool> studied, String topicId, List<Flashcard> flashcards)async{
      try {
        User user = await Controller.getUserInfo();
      List<dynamic> studiedIds=[];
      int counter=0;
      for (bool b in studied){
        if(b){
          studiedIds.add(flashcards[counter].id);
        }
        counter++;
      }

      if(studiedIds.isNotEmpty){
       
         if(user.flashCardsStudied.indexWhere((e)=>e['topic'] == topicId)!=-1){
          for (var topic in user.flashCardsStudied) {
            if(topic["topic"] == topicId){
              topic['studied'] = studiedIds;
         
          }
          await Connection.updateUserFlashcard(user.id, user.flashCardsStudied);
        }}else{
          await Connection.updateStudied(user.id, {
          'topic': topicId,
          'studied':studiedIds
         });
        }
      }
      } catch (e) {
        
      }

    }

}