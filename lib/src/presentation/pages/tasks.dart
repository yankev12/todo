import 'dart:convert';

import 'package:first_project/src/models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var borderRounded =
    new RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    
class TaskPage extends StatefulWidget {
  var items = List<Item>();

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
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

  // void taskDone(int index) {
  //   setState(
  //     () {
  //       widget.items[index].done = true;
  //       save();
  //     },
  //   );
  // }

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
                'Finalizado com Sucesso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.green.withOpacity(0.2),
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Text(
                'Easy easy',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            onDismissed: (direction) {
              setState(
                () {
                  item.done = true;
                  save();
                },
              );
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Manda outra que essa foi fácil'),
              ));
            },
            child: Container(
              child: Text(item.title),
              padding: EdgeInsets.all(10),
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
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Nooooo'),
              ));
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
              mainAxisAlignment: MainAxisAlignment.end,
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
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context, newTask.text);
                    },
                    textColor: Colors.blue[400],
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.blue[400], width: 3)),
                    child: Text('OK',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}