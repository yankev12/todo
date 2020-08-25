import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var borderRounded =
    new RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

class ModalAddTask extends StatelessWidget {
  var newTask = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: borderRounded,
      title: Text(
        "O que nós vamos fazer, Chefe?",
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
                  child:
                      Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
