import 'package:genie_app/viewModel/controller.dart';
import 'package:uuid/uuid.dart';

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

  static Future<List> checkStudyGroup(String groupId) async{
    ObjectId grId = ObjectId.fromHexString(groupId);
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var groupCollection = db.collection('studyGroup');
    List result = await groupCollection.find(where.eq(
        "_id", grId
      )).toList();
    await db.close();
    return result;
    
  }

  static Future<String> checkStudyGroupCode(String enterCode) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();

    var groupCollection = db.collection("studyGroup");
    List result = await groupCollection.find(where.eq(
      "entrance_code",enterCode
    )).toList();

    if(result.isNotEmpty){
    ObjectId objId = result[0]["_id"];
    String toReturn = objId.oid;
    return toReturn;
    } else {
      return "no success";
    }
    

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
  /*static Future joinGroup(User user, String groupCode) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    String resultGroup = await checkStudyGroupCode(groupCode);
    var userCollection = db.collection("user");
    List resultUser = await userCollection.find(where.eq("email", user.email)).toList();
    ObjectId userId = resultUser[0]["_id"];
    List resultUser = 
    

  }*/
  static Future insertNewGroup(User user, Groups group) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    var result = await checkUser(user);
    ObjectId id = result[0]["_id"];
    String objIdString = id.oid;
    //String enterCode = objIdString.substring(2,10);
    var groupCollection = db.collection("studyGroup");
    WriteResult writeResult = await groupCollection.insertOne({
      "name":group.name,
      "description":group.description,
      "creator":objIdString,
      "forums":[],
      "members":[objIdString],
      "topics":[],
      "admins":[objIdString],
      "profile_picture":"",
      "entrance_code":"",
    });
    
    ObjectId insertedStGroupId = await writeResult.id;
    String enterCode = insertedStGroupId.oid.substring(2,10);
    groupCollection.updateOne(where.eq("_id", insertedStGroupId), modify.set("entrance_code", enterCode));
    await db.close();
    return insertedStGroupId.oid;

  }

  static void updateGroupMembers(String groupId, List members) async{
    final db =  await Db.create("mongodb+srv://andreinarivas:Galletas21@cluster0.gbix89j.mongodb.net/demo");
    await db.open();
    print(members);
    var groupCollection = db.collection("studyGroup");
    ObjectId objId = ObjectId.fromHexString(groupId);
    groupCollection.updateOne(where.eq("_id", objId), modify.set("members", members));
    db.close();
    //print(x.id);
  }

}