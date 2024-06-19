import 'dart:convert';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ControllerStudy {
  static Future<String> addNewFlashCard(
      String term, String def, String topicID) async {
    try {
      Flashcard flashcard = Flashcard(term, def);
      await Connection.addNewFlashCard(flashcard, topicID);

      return 'success';
    } catch (e) {



      return 'error';
    }
  }


  static Future<List<Flashcard>> getFlashcards(String topicID) async {
    try {
      return await Connection.getFlashCards(topicID);

   

    } catch (e) {
      return [];
    }
  }

  static Future<String> updateFlashcard(
      Flashcard newFlashcard, String id) async {
    try {
      return await Connection.updateFlashcard(newFlashcard, id);
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> deleteFlashcard(
      String flashcardId, String topicId, int i) async {
    try {
      return await Connection.deleteFlashcard(flashcardId, topicId, i);
    } catch (e) {
      return 'error';
    }
  }

  static Future<User> getUserFromInfo() async {
    final prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    User loggedUser;
    if (user != null) {
      loggedUser = User.fromShared(jsonDecode(user));
      return loggedUser;
    } else {
      return User("", "");
    }
  }

  static Future<List<bool>> checkIfStudied(
      String topicID, List<Flashcard> flashcards) async {
    try {
      User user = await getUserFromInfo();
      User fullUser = await Connection.getUser(user.id);
      List<bool> studiedFlash = [];
      if (fullUser.flashCardsStudied.isNotEmpty) {
        for (var element in fullUser.flashCardsStudied) {
          if (element['topic'] == topicID) {
            List<dynamic> studied = element["studied"] ?? [];
            for (var el in flashcards) {
              if (studied.indexWhere((e) => e == el.id) != -1) {
                studiedFlash.add(true);
              } else {
                studiedFlash.add(false);
              }
            }
          } else {
            // ignore: unused_local_variable
            for (var el in flashcards) {
              studiedFlash.add(false);
            }
          }
        }
      } else {
        // ignore: unused_local_variable
        for (var el in flashcards) {
          studiedFlash.add(false);
        }
        }
        return studiedFlash; 
       }catch (e) {
        print(e);
        List<bool> studiedFlash=[];
        // ignore: unused_local_variable
        for(var el in flashcards){
                studiedFlash.add(false);
          }
        return studiedFlash;
      }}
       


     
  

  

    static Future updateStudied(List<bool> studied, String topicId, List<Flashcard> flashcards)async{
      try {
        User user = await Controller.getUserInfo();
        User fullUser = await Connection.getUser(user.id);

      List<dynamic> studiedIds=[];
      int counter=0;
      for (bool b in studied){
        if(b){

          studiedIds.add(flashcards[counter].id);
        }
        counter++;
      }

      if(studiedIds.isNotEmpty){
       
         if(fullUser.flashCardsStudied.indexWhere((e)=>e['topic'] == topicId)!=-1){
          for (var topic in fullUser.flashCardsStudied) {
            if(topic["topic"] == topicId){

              topic['studied'] = studiedIds;
            }
            await Connection.updateUserFlashcard(
                user.id, user.flashCardsStudied);
          }
          await Connection.updateUserFlashcard(user.id, fullUser.flashCardsStudied);
        }}else{
          await Connection.updateStudied(user.id, {
          'topic': topicId,
          'studied':studiedIds
         });

        }
      }
     catch (e) {}
  }

  static int countStudied(List<bool> studied) {
    int counter = 0;
    for (var bool in studied) {
      if (bool) {
        counter++;
      }
    }
    return counter;
  }


    static Future<double> getPercent(Topic topicId, String userId)async{
      User fullUser = await Connection.getUser(userId);
      List<Flashcard> flashcards = await Connection.getFlashCards(topicId.id);
      if(fullUser.flashCardsStudied.indexWhere((e)=>e['topic']==topicId.id)!=-1){
        List studied = fullUser.flashCardsStudied[fullUser.flashCardsStudied.indexWhere((e)=>e['topic']==topicId.id)]['studied'];
        return studied.length/flashcards.length;
      }else{
        return 0;
      }
      
    }


}
