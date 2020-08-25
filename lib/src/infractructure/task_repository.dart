import 'dart:convert';

import 'package:first_project/src/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  SharedPreferences prefs;

  UserRepository({this.prefs});

  static const String _TASK = "data_tasks";

  Future<List<Item>> getTasks() async {
    var data = await prefs.getString("data");
    var result = new List<Item>();
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      result = decoded.map((itemJson) => Item.fromJson(itemJson)).toList();
    }
    return result;
  }

  save(List<Item> tasks) async {
    await prefs.setString("data", jsonEncode(tasks));
  }

  add(Item task) async {
    List<Item> tasks = await getTasks();
    tasks.add(task);
    save(tasks);
  }

  remove(int index) async {
    List<Item> tasks = await getTasks();
    tasks.removeAt(index);
    save(tasks);
  }
}