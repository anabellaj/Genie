import 'package:genie_app/models/forum_reply.dart';

import 'user.dart';
import 'forum.dart';
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

  static Future<String> insertNewUser(User user) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var userCollection = db.collection('user');
    WriteResult result = await userCollection.insertOne({
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
    return result.id.iod.toString();
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