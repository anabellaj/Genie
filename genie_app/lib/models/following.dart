class Following{
  late String id;
  late List<dynamic> follows;
  late List<dynamic> followed;
  late List<dynamic> requests;
  late List<dynamic> requested;

  Following.fromJson(Map<String,dynamic> json):
    id = json['_id'].oid,
    follows= json['follows'],
    followed = json['followed'],
    requests = json['requests'],
    requested =json['requested'];

  Map<String, dynamic> toJson()=>{
    "follows":follows,
    "followed":followed,
    "requests": requests,
    "requested": requested
  };

}