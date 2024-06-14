import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/connection.dart';


class ControllerStudy {

  static Future<String> addNewFlashCard(String term, String def, String topicID)async{
    try {

      Flashcard flashcard = Flashcard(term, def);
      await Connection.addNewFlashCard(flashcard, topicID);
      

      return 'success';
    } catch (e) {
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

}