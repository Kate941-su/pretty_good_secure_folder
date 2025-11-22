import 'package:isar_community/isar.dart';


part 'holder_schema.g.dart';

@collection
class Holder {
  Id? id;
  String? name;
  String? updateAtString;
  bool? isFavorite;
  List<int>? itemIdList;
}