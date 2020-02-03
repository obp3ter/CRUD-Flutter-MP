import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'All.dart';
import 'MyDrawer.dart';
import 'Recipe.dart';
import 'Repository.dart';
import 'Util.dart';

class Update extends StatefulWidget{
  @override
  UpdateState createState() {
    return UpdateState(entity,id);
  }
  Recipe entity;
  int id;

  Update(this.entity, this.id);


}

class UpdateState extends State<Update>{

  final _formKey = GlobalKey<FormState>();
  Map<String,FocusNode> focusNodes = new Map();
  Map<String,dynamic> params = new Map();
  int id;
  int tid;


  UpdateState(Recipe entity,this.id){
    var util = new Util();
    params.addAll(util.toMapForInternal(entity));
    tid=entity.id;
  }

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
          initialValue: params[k].toString(),
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
          initialValue: params[k].toString(),
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
          initialValue: params[k],
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
        onPressed: () {
          // Validate returns true if the form is valid, or false
          // otherwise.
          if (_formKey.currentState.validate()) {
            // If the form is valid, display a Snackbar.
            var entity = util.fromInternal(params);
            entity.id=tid;
            repository.update(entity);
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
        title: Text("Update"),
      ),

      drawer: getDrawer(context),

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