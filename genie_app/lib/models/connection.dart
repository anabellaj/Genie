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

  static Future addNewForum(Forum forum)async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var forumCollection = db.collection('forum');
    WriteResult result = await forumCollection.insertOne(
      {
        'title':forum.title,
        'description':forum.description,
        'creator':forum.creator,
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


}