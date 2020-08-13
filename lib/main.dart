import 'dart:convert';

import 'package:first_project/models/item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var borderRounded =
    new RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = List<Item>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState() {
    load();
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("data");
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result =
          decoded.map((itemJson) => Item.fromJson(itemJson)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("data", jsonEncode(widget.items));
  }

  void addTask(String nametask) {
    setState(() {
      widget.items.add(Item(title: nametask, done: false));
      save();
    });
  }

  void removeTask(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Widget getItems(List<Item> items) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        var item = items[index];
        return Dismissible(
            key: Key(item.title),
            background: Container(
              color: Colors.green.withOpacity(0.2),
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Excluir a Conquista?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.green.withOpacity(0.2),
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Text(
                'Por Esparta!!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            onDismissed: (direction) {
              removeTask(index);
              final snackBar = SnackBar(
                content: Text('Manda outra que essa foi fácil'),
                action: SnackBarAction(
                  label: 'fechar',
                  onPressed: () {
                    // Some code to undo the change.
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Container(
              child: CheckboxListTile(
                title: Text(item.title),
                key: Key(item.title),
                value: item.done,
                onChanged: (value) {
                  setState(
                    () {
                      item.done = value;
                      save();
                    },
                  );
                },
              ),
              padding: EdgeInsets.all(5),
              width: double.infinity,
              decoration:
                  BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
            ));
      },
    );
  }

  Widget getItemsDone(List<Item> items) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        var item = items[index];
        return Dismissible(
            key: Key(item.title),
            background: Container(
              color: Colors.green.withOpacity(0.2),
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Excluir a Conquista?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.green.withOpacity(0.2),
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Text(
                'Por Esparta!!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            onDismissed: (direction) {
              removeTask(index);
              final snackBar = SnackBar(
                content: Text('Manda outra que essa foi fácil'),
                action: SnackBarAction(
                  label: 'fechar',
                  onPressed: () {
                    // Some code to undo the change.
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Container(
              child: CheckboxListTile(
                title: Text(item.title),
                key: Key(item.title),
                value: item.done,
                onChanged: (value) {
                  setState(
                    () {
                      item.done = value;
                      save();
                    },
                  );
                },
              ),
              padding: EdgeInsets.all(5),
              width: double.infinity,
              decoration:
                  BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Desafios aceitos"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text('Desafios que eu termino com os olhos fechados'),
          ),
          getItems(widget.items.where((element) => !element.done).toList()),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text('Desafios que eu terminei com sucesso'),
          ),
          getItemsDone(widget.items.where((element) => element.done).toList())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: Key("button"),
        child: Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
        onPressed: () async {
          String result = await _incrementTask(context);
          if (result != null && result.isNotEmpty) {
            addTask(result);
          }
        },
      ),
    );
  }
}

Future<String> _incrementTask(context) async {
  var newTask = TextEditingController();
  return showDialog(
    context: context,
    builder: (BuildContext bc) {
      return SimpleDialog(
        shape: borderRounded,
        title: Text(
          "O que nós vamos fazer?",
          style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7)),
          textAlign: TextAlign.left,
        ),
        contentPadding: EdgeInsets.all(10),
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            controller: newTask,
            decoration: new InputDecoration(
              labelText: 'título',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  child: Text('Cancelar'),
                  textColor: Colors.white,
                  color: Colors.blue[400],
                  shape: borderRounded,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context, newTask.text);
                  },
                  textColor: Colors.blue[400],
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blue[400], width: 3)),
                  child:
                      Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

// class ListItems extends StatefulWidget {
//   @override
//   _ListItems createState() => _ListItems();
// }

// class _ListItems extends State<ListItems> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }

// }
