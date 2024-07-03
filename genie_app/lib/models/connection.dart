import 'package:flutter/material.dart';
import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/following.dart';
import 'group.dart';
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

  static Future<List> findUsersByName(String searchValue, String attribute) async{
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var userCollection = db.collection('user');
    final result = await userCollection.find(where.match(attribute, searchValue)).toList();
    await db.close();
    return result;
    
  }
  static Future<List> checkUser(User user) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var userCollection = db.collection('user');
    List result = await userCollection
        .find(where.eq("username", user.username).or(where.eq(
          "email",
          user.email,
        )))
        .toList();
    await db.close();
    return result;
  }
  static Future<String> newFollowing()async{
     final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var followCollection = db.collection('following');
    WriteResult following = await followCollection.insertOne(
      {
        "follows": [],
        "followed":[],
        "requests":[],
        "requested":[]
      }
    );
    return following.id.oid;
  }

  static void removeGroup(Groups group) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var groupCollection = db.collection('studyGroup');
    var userCollection = db.collection("user");
    groupCollection
        .deleteOne(where.eq("_id", ObjectId.fromHexString(group.id.oid)));
    List groupMembers = await userCollection.find({
      "studyGroups": {
        '\$in': [group.id.oid]
      }
    }).toList();
    if (groupMembers.isNotEmpty) {
      for (var member in groupMembers) {
        List currStudyGroups = member["studyGroups"];
        currStudyGroups.remove(group.id.oid);
        final userUpdate =
            ModifierBuilder().set("studyGroups", currStudyGroups);
        userCollection.updateOne(where.eq("_id", member["_id"]), userUpdate);
      }
    }
    await db.close();
  }

  static Future<User> removeGroupMember(String memberId, Groups group) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var groupCollection = db.collection('studyGroup');
    var userCollection = db.collection("user");

    List members = group.members;
    members.remove(memberId);

    List admins = group.admins;

    if (admins.contains(memberId)) {
      admins.remove(memberId);
    }
    if (admins.isEmpty && members.isNotEmpty) {
      admins.add(members[0]);
    }

    final docUser =
        await userCollection.findOne({"_id": ObjectId.fromHexString(memberId)});

    User groupMember = User.fromJson(docUser as Map<String, dynamic>);
    List studyGroups = groupMember.studyGroups;
    studyGroups.remove(group.id.oid);
    groupMember.studyGroups.remove(group.id.oid);

    final groupUpdate =
        ModifierBuilder().set("members", members).set("admins", admins);
    final userUpdate = ModifierBuilder().set("studyGroups", studyGroups);

    groupCollection.updateOne(where.eq("_id", group.id), groupUpdate);
    userCollection.updateOne(
        where.eq("_id", ObjectId.fromHexString(memberId)), userUpdate);

    db.close();
    return groupMember;
  }

  static Future<List<User>> getGroupMembers(List groupMembers) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var userCollection = db.collection("user");
    List<User> groupMembs = [];
    for (String memberId in groupMembers) {
      final docUser = await userCollection
          .findOne({"_id": ObjectId.fromHexString(memberId)});
      User groupMember = User.fromJson(docUser as Map<String, dynamic>);
      groupMember.id = memberId;
      groupMembs.add(groupMember);
    }
    return groupMembs;
  }

  static Future<List> checkStudyGroup(String groupId) async {
    ObjectId grId = ObjectId.fromHexString(groupId);
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var groupCollection = db.collection('studyGroup');
    List result = await groupCollection.find(where.eq("_id", grId)).toList();
    await db.close();
    return result;
  }

  static Future<String> checkStudyGroupCode(String enterCode) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var groupCollection = db.collection("studyGroup");
    List result = await groupCollection
        .find(where.eq("entrance_code", enterCode))
        .toList();

    if (result.isNotEmpty) {
      ObjectId objId = result[0]["_id"];
      String toReturn = objId.oid;
      return toReturn;
    } else {
      return "no success";
    }
  }

  static Future<String> insertNewUser(User user) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
    WriteResult result = await userCollection.insertOne({
      "email": user.email,
      "password": user.password,
      "name": user.name,
      "username": user.username,
      "university": "",
      "career": "",
      "interests": [],
      "chats": [],
      "studyGroups": [],
      'flashCardsStudied': [],
      'replysLiked': [], 
      "following":user.following,
    });
    await db.close();
    return result.id.oid.toString();
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
    var studyGroupCollection = db.collection('studyGroup');
    for (var id in user.studyGroups) {
      await studyGroupCollection.updateOne(
          where.eq('_id', ObjectId.fromHexString(id)),
          ModifierBuilder().pull("members", user.id));
    }

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
    print(response['flashCards']);
    Topic topic = Topic(
        id: id,
        name: response['name'],
        label: response['label'],
        files: studyMaterials,
        flashCards: response['flashCards']);
    db.close();
    return topic;
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
      studyMaterial.id = ObjectIdConverter.convertToId(response.id);
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
    List<int> pdfContent1 = List<int>.from(response!['fileContent']);
    final pdfContent = Uint8List.fromList(pdfContent1.cast());
    return pdfContent;
  }

  static Future<StudyMaterial?> getStudyMaterial(String id) async {
    ObjectId convertedId = ObjectId.fromHexString(id);
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    final studyMaterialCollection = db.collection('studyMaterial');
    final response =
        await studyMaterialCollection.findOne(where.eq('_id', convertedId));

    if (response != null) {
      StudyMaterial studyMaterial = StudyMaterial(
        id: response['id'].toString(),
        title: response['title'],
        description: response['description'],
      );
      return studyMaterial;
    } else {
      return null;
    }
  }

  /*Topic Queries */

  static Future<String> createTopic(
      Topic topic, Groups group, bool labelExists) async {
    try {
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open();
      var topicCollection = db.collection('topic');
      print(topic.toJson());
      WriteResult insert = await topicCollection.insertOne(topic.toJson());
      var groupCollection = db.collection('studyGroup');
      if (labelExists) {
        await groupCollection.updateOne(where.eq('_id', group.id),
            ModifierBuilder().push('topics', insert.id));
      } else {
        await groupCollection.updateOne(
            where.eq('_id', group.id),
            ModifierBuilder()
                .push('topics', insert.id)
                .push('labels', topic.label));
      }

      db.close();
      return 'success';
    } on Exception catch (e) {
      return 'Ocurrio un error $e';
    }
  }

  static Future updateTopic(
      Topic newTopic, Topic oldTopic, bool labelExists, Groups group) async {
    try {
      ObjectId convertedId = ObjectId.fromHexString(oldTopic.id);
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open();
      final topicCollection = db.collection('topic');
      await topicCollection.update(
        where.eq('_id', convertedId),
        ModifierBuilder()
            .set('name', newTopic.name)
            .set('label', newTopic.label),
      );
      if (!labelExists) {
        final groupCollection = db.collection('studyGroup');
        await groupCollection.updateOne(where.eq('_id', group.id),
            ModifierBuilder().push('labels', newTopic.label));
      }
      await db.close();
      return 'success';
    } on Exception catch (e) {
      return e;
    }
  }

  static Future deleteTopic(String strId) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    try {
      ObjectId id = ObjectId.fromHexString(strId);
      var topicCollection = db.collection('topic');
      await topicCollection.remove(where.eq('_id', id));
      await db.close();
      return 'success';
    } on Exception catch (e) {
      return e;
    }
  }

  static Future updateFile(
      StudyMaterial material, String id, String idTopic, int i) async {
    ObjectId convertedId = ObjectId.fromHexString(id);
    ObjectId topicId = ObjectId.fromHexString(idTopic);

    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    final materialCollection = db.collection('studyMaterial');
    final topicCollection = db.collection('topic');
    try {
      await materialCollection.update(
        where.eq('_id', convertedId),
        ModifierBuilder()
            .set('title', material.title)
            .set('description', material.description),
      );
      final topic = await topicCollection.findOne(where.eq('_id', topicId));
      if (topic != null) {
        List materials = topic['studyMaterial'];
        materials[i]['title'] = material.title;
        materials[i]['description'] = material.description;
        await topicCollection.update(
          where.eq('_id', topicId),
          ModifierBuilder().set('studyMaterial', materials),
        );
      }
      db.close();
      return 'success';
    } on Exception catch (e) {
      return e;
    }
  }

  static Future deleteFile(String id, String idTopic, int i) async {
    ObjectId convertedId = ObjectId.fromHexString(id);
    ObjectId topicId = ObjectId.fromHexString(idTopic);

    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    final materialCollection = db.collection('studyMaterial');
    final topicCollection = db.collection('topic');
    try {
      await materialCollection.remove(where.eq('_id', convertedId));
      final topic = await topicCollection.findOne(where.eq('_id', topicId));
      if (topic != null) {
        List materials = topic['studyMaterial'];
        materials.removeAt(i);
        await topicCollection.update(
          where.eq('_id', topicId),
          ModifierBuilder().set('studyMaterial', materials),
        );
      }
      await db.close();
      return 'success';
    } on Exception catch (e) {
      return e;
    }
  }

  static Future<List> getTopics(String groupId) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final groupCollection = db.collection('studyGroup');
    final topicCollection = db.collection('topic');

    Map<String, dynamic>? result = await groupCollection
        .findOne(where.eq("_id", ObjectId.fromHexString(groupId)));

    List allTopics = [];

    if (result != null) {
      for (var t in result['topics']) {
        Map<String, dynamic>? topic =
            await topicCollection.findOne(where.eq("_id", t));
        if (topic != null) {
          allTopics.add(topic);
        }
      }
    }

    return allTopics;
  }

  /*Forum Queries */
  static Future addNewForum(Forum forum, Groups group) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var forumCollection = db.collection('forum');
    WriteResult result = await forumCollection.insertOne({
      'title': forum.title,
      'description': forum.description,
      'creator': forum.creator,
      'creator_id': forum.creator_id,
      'date': forum.date,
      'answers': forum.answers
    });

    var studyGroupsCollection = db.collection('studyGroup');
    // Hacer dinamico con el grupo de estudio en el que estas
    await studyGroupsCollection.updateOne(
        where.eq("_id", group.id), ModifierBuilder().push('forums', result.id));
  }

  static Future<Forum> refreshForum(String forumId) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    final forumCollection = db.collection('forum');

    Map<String, dynamic>? result = await forumCollection
        .findOne(where.eq("_id", ObjectId.fromHexString(forumId)));

    return Forum.fromJson(result!);
  }

  static Future<List> returnForums(String groupId) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final studyGroupCollection = db.collection('studyGroup');
    Map<String, dynamic>? result = await studyGroupCollection
        .findOne(where.eq('_id', ObjectId.fromHexString(groupId)));

    if (result != null) {
      List forumList = [];
      final forumCollection = db.collection('forum');
      for (var id in result['forums']) {
        Map<String, dynamic>? forumFound =
            await forumCollection.findOne(where.eq('_id', id));
        if (forumFound != null) {
          forumList.add(forumFound);
        }
      }

      return forumList;
    } else {
      return [];
    }
  }

  static Future removeForum(String forum, String group) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final forumReplyCollection = db.collection('forumAnswer');
    final forumCollection = db.collection('forum');

    Map<String, dynamic>? found = await forumCollection
        .findOne(where.eq('_id', ObjectId.fromHexString(forum)));

    await forumCollection
        .deleteOne(where.eq('_id', ObjectId.fromHexString(forum)));

    for (var ans in found!['answers']) {
      await forumReplyCollection.deleteOne(where.eq('_id', ans));
    }

    final studyGroupCollection = db.collection('studyGroup');

    await studyGroupCollection.updateOne(
        where.eq('_id', ObjectId.fromHexString(group)),
        ModifierBuilder().pull('forums', ObjectId.fromHexString(forum)));

    db.close();
  }

  static Future<List> returnAnswers(String forumId) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final forumCollection = db.collection('forum');
    Map<String, dynamic>? result = await forumCollection
        .findOne(where.eq('_id', ObjectId.fromHexString(forumId)));

    if (result != null) {
      List replyList = [];
      final forumAnswerCollection = db.collection('forumAnswer');
      for (var id in result['answers']) {
        Map<String, dynamic>? replyFound =
            await forumAnswerCollection.findOne(where.eq('_id', id));
        if (replyFound != null) {
          replyList.add(replyFound);
        }
      }
      await db.close();

      return replyList;
    } else {
      return [];
    }
  }

  static Future<String> addNewReply(ForumReply newReply, String forumId) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final forumReplyCollection = db.collection('forumAnswer');
    final forumCollection = db.collection('forum');

    WriteResult result = await forumReplyCollection.insertOne({
      'creator': newReply.creator,
      'date': newReply.date,
      'message': newReply.message,
      'creator_id': newReply.creator_id,
      'num_likes': newReply.num_likes
    });

    await forumCollection.updateOne(
        where.eq('_id', ObjectId.fromHexString(forumId)),
        ModifierBuilder().push('answers', result.id));

    db.close();
    return result.id.oid.toString();
  }

  static Future removeAnswer(String answer, String forum) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    final forumReply = db.collection('forumAnswer');

    await forumReply.deleteOne(where.eq('_id', ObjectId.fromHexString(answer)));

    final forumCollection = db.collection('forum');

    await forumCollection.updateOne(
        where.eq("_id", ObjectId.fromHexString(forum)),
        ModifierBuilder().pull('answers', ObjectId.fromHexString(answer)));

    db.close();
  }

  /*Study Goup Queries Queries */
  static Future insertNewGroup(User user, Groups group) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var result = await checkUser(user);
    ObjectId id = result[0]["_id"];
    String objIdString = id.oid;
    //String enterCode = objIdString.substring(2,10);
    var groupCollection = db.collection("studyGroup");
    WriteResult writeResult = await groupCollection.insertOne({
      "name": group.name,
      "description": group.description,
      "creator": objIdString,
      'labels': [],
      "forums": [],
      "members": [objIdString],
      "topics": [],
      "admins": [objIdString],
      "profile_picture": "",
      "entrance_code": "",
    });

    ObjectId insertedStGroupId = await writeResult.id;
    String enterCode = insertedStGroupId.oid.substring(2, 10);
    groupCollection.updateOne(where.eq("_id", insertedStGroupId),
        modify.set("entrance_code", enterCode));
    await db.close();
    return insertedStGroupId.oid;
  }

  static void updateGroupMembers(String groupId, List members) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var groupCollection = db.collection("studyGroup");
    ObjectId objId = ObjectId.fromHexString(groupId);
    groupCollection.updateOne(
        where.eq("_id", objId), modify.set("members", members));
    db.close();
  }

  static void setNewGroupInfo(
      String name, String description, String groupId) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var groupCollection = db.collection("studyGroup");
    ObjectId objId = ObjectId.fromHexString(groupId);
    final update =
        ModifierBuilder().set("name", name).set("description", description);
    groupCollection.updateOne(where.eq("_id", objId), update);
    db.close();
  }

  static Future updateLabels(String groupId, List<dynamic> labels) async {
    ObjectId convertedId = ObjectId.fromHexString(groupId);

    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    final groupCollection = db.collection('studyGroup');
    try {
      await groupCollection.update(
        where.eq('_id', convertedId),
        ModifierBuilder().set('labels', labels),
      );

      await db.close();
      return 'success';
    } on Exception catch (e) {
      return e;
    }
  }

  static Future addNewFlashCard(Flashcard flash, String topicID) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    final flashcardCollection = db.collection('flashcard');

    WriteResult res = await flashcardCollection
        .insertOne({"term": flash.term, "definition": flash.definition});

    final topicCollection = db.collection('topic');
    await topicCollection.updateOne(
        where.eq("_id", ObjectId.fromHexString(topicID)),
        ModifierBuilder().push('flashCards', res.id));
    await db.close();
  }

  static Future<List<Flashcard>> getFlashCards(String topicID) async {
    try {
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open();
      final topicCollection = db.collection('topic');
      final flashcardCollection = db.collection('flashcard');

      final topic = await topicCollection
          .findOne(where.eq("_id", ObjectId.fromHexString(topicID)));
      final flashcardIds = topic?['flashCards'];

      final flashcards = await flashcardCollection
          .find(where.oneFrom("_id", flashcardIds))
          .toList();

      final List<Flashcard> flashcardObjects = flashcards.map((flashcard) {
        return Flashcard.fromJson(flashcard);
      }).toList();

      return flashcardObjects;
    } on Exception catch (e) {
      print('Error in all flashcards: $e');
      return [];
    }
  }

  static Future<dynamic> updateFlashcard(
      Flashcard newFlashcard, String id) async {
    try {
      ObjectId convertedId = ObjectId.fromHexString(id);
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open();
      final flashcardCollection = db.collection('flashcard');
      await flashcardCollection.update(
        where.eq('_id', convertedId),
        ModifierBuilder()
            .set('term', newFlashcard.term)
            .set('definition', newFlashcard.definition),
      );
      await db.close();
      return 'success';
    } on Exception catch (e) {
      print(e);
      return e;
    }
  }

  static Future<dynamic> deleteFlashcard(
      String flashcardId, String topicId, int i) async {
    try {
      ObjectId convertedIdFlashcard = ObjectId.fromHexString(flashcardId);
      ObjectId convertedIdTopic = ObjectId.fromHexString(topicId);
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

      await db.open();
      final flashcardCollection = db.collection('flashcard');
      final topicCollection = db.collection('topic');
      await flashcardCollection.remove(where.eq('_id', convertedIdFlashcard));

      final topic =
          await topicCollection.findOne(where.eq('_id', convertedIdTopic));
      if (topic != null) {
        List flashcards = topic['flashCards'];
        flashcards.removeAt(i);
        await topicCollection.update(
          where.eq('_id', convertedIdTopic),
          ModifierBuilder().set('flashCards', flashcards),
        );
      }

      await db.close();
      return 'success';
    } on Exception catch (e) {
      print(e);
      return e;
    }
  }

  static Future updateStudied(
      String userId, Map<String, dynamic> object) async {
    try {
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

      await db.open();
      final userCollection = db.collection('user');
      await userCollection.updateOne(
          where.eq('_id', ObjectId.fromHexString(userId)),
          ModifierBuilder().addToSet('flashCardsStudied', object));
      await db.close();
    } catch (e) {}
  }

  static Future<User> getUser(String id) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

    await db.open();
    final userCollection = db.collection('user');
    Map<String, dynamic>? res = await userCollection
        .findOne(where.eq("_id", ObjectId.fromHexString(id)));
    await db.close();
    if (res != null) {
      return User.fromJson(res);
    } else {
      return User("", "");
    }
  }

  static Future updateUserFlashcard(String userId, List<dynamic> object) async {
    try {
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

      await db.open();
      final userCollection = db.collection('user');
      await userCollection.updateOne(
          where.eq('_id', ObjectId.fromHexString(userId)),
          ModifierBuilder().set('flashCardsStudied', object));
      await db.close();
    } catch (e) {}
  }

  static Future updateLikesInReplys(List replysId) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

    await db.open();
    final forumReplyCollection = db.collection('forumAnswer');
    for (var reply in replysId) {
      await forumReplyCollection.updateOne(
          where.eq("_id", ObjectId.fromHexString(reply)),
          ModifierBuilder().inc("num_likes", 1));
    }
    await db.close();
  }

  static Future updateUserLikedReplys(String userId, dynamic object) async {
    try {
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

      await db.open();
      final userCollection = db.collection('user');
      await userCollection.updateOne(
          where.eq('_id', ObjectId.fromHexString(userId)),
          ModifierBuilder().set('replysLiked', object));
      await db.close();
    } catch (e) {}
  }

  static Future addUserLikedReplys(String userId, dynamic object) async {
    try {
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

      await db.open();
      final userCollection = db.collection('user');
      await userCollection.updateOne(
          where.eq('_id', ObjectId.fromHexString(userId)),
          ModifierBuilder().addToSet('replysLiked', object));
      await db.close();
    } catch (e) {}
  }

  static Future removeLikes(List remove) async {
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

    await db.open();
    final answerCollection = db.collection('forumAnswer');
    for (var rem in remove) {
      await answerCollection.updateOne(
          where.eq("_id", rem), ModifierBuilder().inc('num_likes', -1));
    }
  }

  static Future<Following> getFollowRequests(User user)async{
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

    await db.open();
    final followingCollection = db.collection('following');
    Map<String, dynamic>? result = await followingCollection.findOne(where.eq("_id", ObjectId.fromHexString(user.following)));
    if(result!=null){
      return Following.fromJson(result);
    }else{
      return Following.fromJson({
        "follows":[],
        "followed":[],
        "requests": [],
        "requested": []
      });
    }
  }


  static Future setRequests(Following f, String following)async{
    final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

    await db.open();
    final followingCollection = db.collection('following');
    await followingCollection.replaceOne(where.eq("_id", ObjectId.fromHexString(following)), f.toJson());
  }
  
  static Future addFollow(List<dynamic> added, String userid)async{
     final db = await Db.create(
        "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");

    await db.open();
    final followingCollection = db.collection("following");
    final userCollection = db.collection('user');
    for(var add in added){
      Map<String,dynamic>? id = await userCollection.findOne(where.eq("_id", ObjectId.fromHexString(add)));
      if(id!=null){
        print(id['following']);
        await followingCollection.updateOne(where.eq("_id", ObjectId.fromHexString(id["following"])), ModifierBuilder().push("follows", userid));
      }
    }
    await db.close();
  }

  static Future <int> checkRequestsFollowing (User user, String followedUser) async {
    try{
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open(); 
      final userCollection = db.collection('user');
      final followingCollection = db.collection('following');

      ObjectId mainUserId = ObjectId.fromHexString(user.id);
      ObjectId secondaryUserId = ObjectId.fromHexString(followedUser);
      
    final userResult = await userCollection.findOne(where.id(mainUserId));
    
    final followingResult = await followingCollection.findOne(where.eq('_id', userResult?['following']));
      
        if (followingResult?['followed'].contains(secondaryUserId)) {
          return 1;
        }
        
        if (followingResult?['requested'].contains(secondaryUserId)) {
          return 2;
        }
        
        return 3;
      
    } 
    catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  static Future addRequest (User currentUser, String followedUserId) async {
    try{
      final db = await Db.create(
          "mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
      await db.open(); 
      final userCollection = db.collection('user');
      final followingCollection = db.collection('following');
      
      ObjectId mainUserId = ObjectId.fromHexString(currentUser.id);
      ObjectId secondaryUserId = ObjectId.fromHexString(followedUserId);

      final mainUserResult = await userCollection.findOne(where.id(mainUserId));
      final secondaryUserResult = await userCollection.findOne(where.id(secondaryUserId));

      final mainRequested = await followingCollection.findOne(where.eq('_id', mainUserResult?['following']));
      final secondaryRequest = await followingCollection.findOne(where.eq('_id', secondaryUserResult?['following']));
      
      List mainRequestedUsers = mainRequested?['requested'];
      mainRequestedUsers.add(followedUserId);
      await followingCollection.update(
        where.eq('_id', mainUserResult?['following']),
        ModifierBuilder().set('requested', mainRequestedUsers),
      );

      List secondaryRequestsList = secondaryRequest?['requests'];
      Object userInfo = {'Id': currentUser.id, 'username': currentUser.username};
      secondaryRequestsList.add(userInfo);
      await followingCollection.update(
        where.eq('_id', secondaryUserResult?['following']),
        ModifierBuilder().set('requests', secondaryRequestsList),
      );

      await db.close();


    } catch (e){
      print('Error: $e');
    }




  }

}
