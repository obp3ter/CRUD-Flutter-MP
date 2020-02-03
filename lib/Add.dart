import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reflectable/reflectable.dart';

import 'All.dart';
import 'Repository.dart';
import 'Util.dart';

class Add extends StatefulWidget{
  @override
  AddState createState() {
    return AddState();
  }
}

class AddState extends State<Add>{

  final _formKey = GlobalKey<FormState>();
  Map<String,FocusNode> focusNodes = new Map();
  Map<String,dynamic> params = new Map();

  @override
  Widget build(BuildContext context) {

    Repository repository= Repository.repo;
    var util = new Util();
    util.getMap().forEach((k,v) => focusNodes[k]= new FocusNode());
    List<Widget> fields = new List();

    var tempMap = util.getMap();
    tempMap.remove('id');
    tempMap.forEach((k,v)=>{
      if(v=='int')
        fields.add(TextFormField(
          focusNode: focusNodes[k],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: k
          ),
          validator: (value) {
//            if (value.isEmpty) {
//              return 'Please enter a vaild '+k+'!';
//            }
            return null;
          },
          onChanged: (data) {
            setState( () => params[k] =int.parse(data));
          },
        )),
      if(v=='double')
        fields.add(TextFormField(
          focusNode: focusNodes[k],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: k
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a vaild '+k+'!';
            }
            return null;
          },
          onChanged: (data) {
            setState( () => params[k] =double.parse(data));
          },
        )),

      if(v=='String')
        fields.add(TextFormField(
          focusNode: focusNodes[k],
          decoration: InputDecoration(
              labelText: k
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a vaild '+k+'!';
            }
            return null;
          },
          onChanged: (data) {
            setState( () => params[k] = data);
          },
        ))

    });


    fields.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () async {
          // Validate returns true if the form is valid, or false
          // otherwise.
                      if (_formKey.currentState.validate()) {
                        await repository.add(util.fromInternal(params));
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => All()
                        ));
                      }
        },
        child: Text('Submit'),
      ),
    ));

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Add"),
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fields
            ),
          )


      ),
    );

    return null;
  }
}