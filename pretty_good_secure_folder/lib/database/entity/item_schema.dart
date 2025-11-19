import 'package:isar_community/isar.dart';

part 'item_schema.g.dart';

@collection
class Item {
  Id? id;
  String? key;
  String? value;
}