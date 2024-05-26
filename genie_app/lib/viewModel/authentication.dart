

import 'package:mongo_dart/mongo_dart.dart';

class Authenticate{

  static Future<String> registerUser(String email, String password, String name) async{
    try {
      final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open();

      var userCollection = db.collection('user');
      List result = await userCollection.find(where.eq(
        "email", email,
      )).toList();
      if(!result.isNotEmpty){
        await userCollection.insertOne({
        "email": email,
        "name":name,
        "password":password
      });
        return "success";
      }else{
        return "user_exists";
      }
    } catch (e) {
      return "error";
    }

    
    
  }

 

}