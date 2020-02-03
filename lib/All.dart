import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'MyDrawer.dart';
import 'Repository.dart';
import 'Update.dart';
import 'Util.dart';

class All extends StatelessWidget {
  Repository repository = Repository.repo;

  Util util = new Util();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("List"),
      ),
      drawer: getDrawer(context),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child: FutureBuilder(
            future: repository.ping(),
            builder: (context,snapshot){
              if (snapshot.hasData) {
                var online=snapshot.data;
                if(online)
                {
                  return FutureBuilder(
                      future: repository.getAll(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var items = snapshot.data;
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              height:
                              20;
                              color:
                              Colors.blue;
                              child:
                              return Card(
                                  key: UniqueKey(),
                                  child: Column(
                                    children: <Widget>[
                                      Text(util.toBeautifulString(items[index])),
                                      ButtonBar(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          RaisedButton(
                                            onPressed: () {
                                              repository.remove(items[index].id);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                          All()));
                                            },
                                            child: Text("Delete"),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                          Update(
                                                              items[index], index)));
                                            },
                                            child: Text("Update"),
                                          )
                                        ],
                                      )
                                    ],
                                  ));
                            },
                          ).build(context);
                        } else if (snapshot.hasError) {
                          Fluttertoast.showToast(
                              msg: snapshot.error.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.black,
                              fontSize: 16.0
                          );
                          return Text("");
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                }
                else
                {
                  return FutureBuilder(
                      future: repository.getAll(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var items = snapshot.data;
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              height:
                              20;
                              color:
                              Colors.blue;
                              child:
                              return Card(
                                  key: UniqueKey(),
                                  child: Column(
                                    children: <Widget>[
                                      Text(util.toBeautifulStringWithoutID(items[index])),
                                    ],
                                  ));
                            },
                          ).build(context);
                        } else if (snapshot.hasError) {
                          Fluttertoast.showToast(
                              msg: snapshot.error.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.black,
                              fontSize: 16.0
                          );
                          return Text("");
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                }

              }
              else if (snapshot.hasError) {
                Fluttertoast.showToast(
                    msg: snapshot.error.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.black,
                    fontSize: 16.0
                );
                return Text("");
              } else {
                return CircularProgressIndicator();
              }

            },
          )),
    );

    return null;
  }
}

/*

 */