

class ForumReply{
  late String id;
  late String creator;
  late String creator_id;
  late DateTime date;
  late String message;

  ForumReply(String creatorParam, DateTime dateParam, String messageParam, String creator_idParam){
    creator=creatorParam;
    date = dateParam;
    message = messageParam;
    creator_id=creator_idParam;
  }

  Map<String,dynamic> toJson()=>{
    'id':id.toString(),
    'creator':creator,
    'date':date,
    'message':message,
    'creator_id': creator_id,
  };

  ForumReply.fromJson(Map<String,dynamic> json):
    id= json["_id"] is String?  json['_id']:json['_id'].oid.toString(),
    creator= json['creator'],
    date = json['date'],
    message= json['message'],
    creator_id = json["creator_id"] is String?  json['creator_id']:json['creator_id'].oid.toString();


}