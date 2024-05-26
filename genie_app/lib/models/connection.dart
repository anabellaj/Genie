import 'user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Connection{

  static Future<List> checkUser(User user) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
      List result = await userCollection.find(where.eq(
        "email", user.email,
      )).toList();
    await db.close();
    return result;
  }

  static Future insertNewUser(User user) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
    await userCollection.insertOne({
      "email": user.email,
      "password": user.password,
      "name":user.name,
    });
    await db.close();
  }


}