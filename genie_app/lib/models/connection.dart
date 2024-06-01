
import 'dart:io';
import 'dart:typed_data';
import 'package:genie_app/models/forum_reply.dart';
import 'package:genie_app/models/object_id_converter.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/models/topic.dart';


import 'user.dart';
import 'forum.dart';
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


  static Future<String> insertNewUser(User user) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
    WriteResult result = await userCollection.insertOne({
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
    return result.id.iod.toString();
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

  static Future addNewForum(Forum forum)async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var forumCollection = db.collection('forum');
    WriteResult result = await forumCollection.insertOne(
      {
        'title':forum.title,
        'description':forum.description,
        'creator':forum.creator,
        'creator_id': forum.creator_id,
        'date':forum.date,
        'answers':forum.answers
      }
    );

    var studyGroupsCollection = db.collection('studyGroup');
    // Hacer dinamico con el grupo de estudio en el que estas 
    await studyGroupsCollection.updateOne(
      where.eq("_id", ObjectId.fromHexString("66552c763656b63721956447")), 
      ModifierBuilder().push('forums', result.id)
    );

  }

  static Future<List> returnForums(String groupId)async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final studyGroupCollection = db.collection('studyGroup');
    Map<String,dynamic>? result = await studyGroupCollection.findOne(
      where.eq('_id', ObjectId.fromHexString(groupId))
    );
   

    if(result != null){
      List forumList=[];
      final forumCollection = db.collection('forum');
      for (var id in result['forums']) {
        Map<String,dynamic>? forumFound = await forumCollection.findOne(
          where.eq('_id', id)
        );
        if(forumFound!=null){
          forumList.add(forumFound);
        }
      }

      return forumList;
    }else{
      return [];
    }

  }

  static Future<List> returnAnswers(String forumId)async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final forumCollection = db.collection('forum');
    Map<String,dynamic>? result = await forumCollection.findOne(
      where.eq('_id', ObjectId.fromHexString(forumId))
    );

    if(result != null){
      List replyList=[];
      final forumAnswerCollection = db.collection('forumAnswer');
      for (var id in result['answers']) {
        Map<String,dynamic>? replyFound = await forumAnswerCollection.findOne(
          where.eq('_id', id)
        );
        if(replyFound!=null){
          replyList.add(replyFound);
        }
      }
      await db.close();

      return replyList;
    }else{
      return [];
    }

  }

  static Future<String> addNewReply(ForumReply newReply, String forumId)async{
      final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open();

      final forumReplyCollection = db.collection('forumAnswer');
      final forumCollection = db.collection('forum');

      WriteResult result = await forumReplyCollection.insertOne(
        {
          'creator': newReply.creator,
          'date': newReply.date,
          'message': newReply.message,
          'creator_id':newReply.creator_id,
        }
      );

      await forumCollection.updateOne(
        where.eq('_id', ObjectId.fromHexString(forumId)
      	), 
          ModifierBuilder().push(
            'answers', result.id
          )
        );

        db.close();
      return result.id.oid.toString();
  }

  static Future removeForum(String forum, String group)async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final forumReplyCollection = db.collection('forumAnswer');
    final forumCollection = db.collection('forum');

    Map<String,dynamic>? found = await forumCollection.findOne(where.eq('_id', ObjectId.fromHexString(forum)));

    await forumCollection.deleteOne(
      where.eq('_id', ObjectId.fromHexString(forum))
    );

    for (var ans in found!['answers']) {
      await forumReplyCollection.deleteOne(
        where.eq('_id', ans)
      );
      
    }

    final studyGroupCollection = db.collection('studyGroup');

    await studyGroupCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(group))
      , ModifierBuilder().pull('forums', ObjectId.fromHexString(forum)));

   db.close();
  }

  static Future removeAnswer(String answer, String forum)async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final forumReply = db.collection('forumAnswer');

    await forumReply.deleteOne(
      where.eq('_id', ObjectId.fromHexString(answer))
    );

    final forumCollection = db.collection('forum');

    await forumCollection.updateOne(
      where.eq("_id", ObjectId.fromHexString(forum))
      , 
      ModifierBuilder().pull('answers', ObjectId.fromHexString(answer)));
    
    db.close();
  }

  static Future<Forum> refreshForum(String forumId)async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    final forumCollection = db.collection('forum');

    Map<String,dynamic>? result = await forumCollection.findOne(
      where.eq("_id", ObjectId.fromHexString(forumId))
    );


    return Forum.fromJson(result!);

  }



}
