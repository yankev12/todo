class Item {
  int id;
  String title;
  bool done;

  Item({this.title, this.done});

  // https://javiercbk.github.io/json_to_dart/
  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}