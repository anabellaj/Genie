


import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Authenticate{

  static Future<String> registerUser(String email, String password, String name) async{
    try {
      final prefs = await SharedPreferences.getInstance();

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
        await prefs.setBool('isLoggedIn', true);
        await prefs.setStringList("user", [email, name, password]);
        await db.close();
        return "success";
      }else{
        await db.close();
        return "user_exists";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> loginUser(String email, String password) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open();
      var userCollection = db.collection('user');
      List result = await userCollection.find(where.eq(
        "email", email,
      )).toList();
      db.close();
      if(result.isNotEmpty){
        
        if(result[0]["password"]==password){
          await prefs.setBool('isLoggedIn', true);
          await prefs.setStringList("user", [result[0]["email"], result[0]["name"], result[0]["password"]]);
          return "success";
        }else{
          return "wrong_credentials";
        }
      }else{
        return "user_doesnt_exist";
      }

      
    } catch (e) {
      return "error";
    }
  }

 

}