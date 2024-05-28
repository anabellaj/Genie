import 'package:genie_app/models/topic.dart';

import 'user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Connection {
  /*User queries*/
  static Future<List> checkUser(User user) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var userCollection = db.collection('user');
    List result = await userCollection
        .find(where.eq(
          "email",
          user.email,
        ))
        .toList();
    await db.close();
    return result;
  }

  static Future insertNewUser(User user) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
    await userCollection.insertOne({
      "email": user.email,
      "password": user.password,
      "name": user.name,
      "username": "",
      "university": "",
      "career": "",
      "interests": [],
      "chats": [],
      "studyGroups": [],
    });
    await db.close();
  }

  static Future updateUser(User user) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
    await userCollection.replaceOne(
        where.eq('email', user.email), user.toJson());

    await db.close();
  }

  static Future removeUser(User user) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
    await userCollection.remove(where.eq('email', user.email));
    await db.close();
  }

  /*Topic queries*/
  static Future<List<Topic>> readTopics() async {
    List<Topic> topics = [];
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var topicCollection = db.collection('topic');
    db.close();
    return topics;
  }

  static Future<String> createTopic(Topic topic) async {
    print('Creo Topico');
    try {
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      print('Creo la BD');
      await db.open();
      print('Abro la BD');
      var topicCollection = db.collection('topic');
      print('Imprimre el mapa');
      print(topic.jsonifica());
      topicCollection.insertOne(topic.jsonifica());
      db.close();
      return 'success';
    } on Exception catch (e) {
      final error = e;
      print(e);
      return 'Ocurrio un error $e';
    }
  }
}
