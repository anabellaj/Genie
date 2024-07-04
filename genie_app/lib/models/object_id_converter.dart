import 'package:mongo_dart/mongo_dart.dart';

class ObjectIdConverter {
  static String convertToId(ObjectId id) {
    String convertedId = id.toString().substring(10, 34);
    return convertedId;
  }
  static ObjectId convertToObject(String id) {
    ObjectId convertedId = ObjectId.fromHexString(id);
    return convertedId;
  }
}
