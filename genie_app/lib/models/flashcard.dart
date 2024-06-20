

class Flashcard{
  late String id;
  late String term;
  late String definition;
  

  Flashcard(String termParam, String definitionParam){
    term=termParam;
    definition= definitionParam;

  }

  Map<String,dynamic> toJson() =>{
    'id':id,
    'term':term,
    'definition':definition,
  };

  Flashcard.fromJson(Map<String,dynamic> json):
    id= json['_id'].oid.toString(),
    term = json['term'],
    definition = json['definition'];
  
}

