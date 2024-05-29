import 'group.dart';
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
      "username":"",
      "university":"",
      "career":"",
      "interests":[],
      "chats": [],
      "studyGroups":[],
    });
    await db.close();
  }
  
  static Future updateUser(User user) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
    await userCollection.replaceOne(where.eq('email', user.email), user.toJson());

    await db.close();
  }
  static Future removeUser(User user)async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
    await userCollection.remove(where.eq('email', user.email));

    await db.close();
  }
  //No funciona
  static Future insertNewGroup(User user, Groups group) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var result = await checkUser(user);
    ObjectId id = result[0]["_id"];
    var groupCollection = db.collection("studyGroup");
    await groupCollection.insertOne({
      "name":group.name,
      "description":group.description,
      "creator":id,
      "forums":[],
      "members":[id],
      "topics":[],
      "admins":[id],
      "profile_picture":""
    });
    await db.close();
  }
}