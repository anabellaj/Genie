import 'dart:io';
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
    ObjectId castedId = ObjectId.fromHexString(id);
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var topicCollection = db.collection('topic');
    final response = await topicCollection.findOne(where.eq('_id', castedId));
    List<StudyMaterial> studyMaterials = [];
    for (var studyMaterial in response!['studyMaterial']) {
      studyMaterials.add(StudyMaterial(
          id: ObjectIdConverter.convertToId(studyMaterial['_id']),
          title: studyMaterial['title'] as String,
          description: studyMaterial['description'] as String));
    }
    Topic topic = Topic(
        id: id,
        name: response['name'],
        description: response['description'],
        label: response['label'],
        files: studyMaterials);
    db.close();
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
      ObjectId id = ObjectId.fromHexString(topic.id);
      final topicCollection = db.collection('topic');
      await topicCollection.update(
          where.eq('_id', id),
          modify.push('studyMaterial', {
            '_id': response.id,
            'title': studyMaterial.title,
            'description': studyMaterial.description,
          }));
      db.close();
      return 'success';
    } on Exception catch (e) {
      return ('Error $e');
    }
  }

  static Future<Uint8List> getFileById(String id) async {
    ObjectId convertedId = ObjectId.fromHexString(id);
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    final studyMaterialCollection = db.collection('studyMaterial');
    final response =
        await studyMaterialCollection.findOne(where.eq('_id', convertedId));
    print(response!['fileContent'].runtimeType);
    List<int> pdfContent1 = List<int>.from(response!['fileContent']);
    final pdfContent = Uint8List.fromList(pdfContent1.cast());
    return pdfContent;
  }

  static Future updateTopic(Topic topic, String previous) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();  
    final topicCollection = db.collection('topic');
    try{await topicCollection.update(
      where.eq('name', previous),
      ModifierBuilder()
        .set('name', topic.name)
        .set('description', topic.description)
        .set('label', topic.label),
    );
  
    await db.close();
    return 'success';
    } on Exception catch (e){
        return e;
    }
  }

  static Future deleteTopic(String strId) async{
      final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
     await db.open();
    try{
    ObjectId id = ObjectId.fromHexString(strId);
    var topicCollection = db.collection('topic');
    await topicCollection.remove(where.eq('_id', id));
    await db.close();
    return 'success';
    } on Exception catch (e){
      return e; 
    }
  }



}
