import 'dart:convert';
import 'dart:typed_data';

import 'package:genie_app/models/object_id_converter.dart';
import 'package:genie_app/models/study_material.dart';
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
  static Future<Topic> readTopic(String id) async {
    print('Entre a la Funcion read topic');
    ObjectId castedId = ObjectId.fromHexString(id);
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    print('Abri la BD');
    var topicCollection = db.collection('topic');
    final response = await topicCollection.findOne(where.eq('_id', castedId));
    print('Llegue aqui 1');
    List<StudyMaterial> studyMaterials = [];
    print(response!['studyMaterial']);
    for (var studyMaterial in response!['studyMaterial']) {
      print('Entre');
      studyMaterials.add(StudyMaterial(
          id: ObjectIdConverter.convertToId(studyMaterial['_id']),
          title: studyMaterial['title'] as String,
          description: studyMaterial['description'] as String));
    }
    print('Llegue aqui 2');
    Topic topic = Topic(
        id: id,
        name: response['name'],
        description: response['description'],
        label: response['label'],
        files: studyMaterials);
    db.close();
    print('La cerre');
    return topic;
  }

  static Future<String> createTopic(Topic topic) async {
    try {
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open();
      var topicCollection = db.collection('topic');
      topicCollection.insertOne(topic.toJson());
      db.close();
      return 'success';
    } on Exception catch (e) {
      final error = e;
      print(e);
      return 'Ocurrio un error $e';
    }
  }

  /*StudyMaterials queries*/
  static Future<String> addStudyMaterialToTopic(
      Topic topic, StudyMaterial studyMaterial, Uint8List fileContent) async {
    try {
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open();
      final studyMaterialCollection = db.collection('studyMaterial');
      WriteResult response = await studyMaterialCollection.insertOne({
        'title': studyMaterial.title,
        'description': studyMaterial.description,
        'fileContent': fileContent
      });
      if (response.isFailure) {
        throw Exception();
      }
      print(response);
      ObjectId id = ObjectId.fromHexString(topic.id);
      final topicCollection = db.collection('topic');
      final response2 = await topicCollection.update(
          where.eq('_id', id),
          modify.push('studyMaterial', {
            '_id': response.id,
            'title': studyMaterial.title,
            'description': studyMaterial.description,
          }));
      print(response2);
      db.close();
      return 'success';
    } on Exception catch (e) {
      return ('Error $e');
    }
  }
}
