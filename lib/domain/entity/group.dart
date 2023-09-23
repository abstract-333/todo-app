import 'package:hive/hive.dart';
part 'group.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject {
  //last used HiveField Key 1
  @HiveField(0)
  String name;

  Group({
    required this.name,
  });
}
