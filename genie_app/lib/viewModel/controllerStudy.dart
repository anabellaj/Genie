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

}