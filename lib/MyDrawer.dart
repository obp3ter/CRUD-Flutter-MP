import 'package:flutter/material.dart';

import 'Add.dart';
import 'All.dart';

Drawer getDrawer(BuildContext context){
  return new Drawer(
      child: ListView(

                children: <Widget>[
//                  UserAccountsDrawerHeader(
//                    accountName: Text("Péter Oprea-Benkő"),
//                    accountEmail: Text(username),
//                    currentAccountPicture: CircleAvatar(
//                      backgroundColor:
//                      Theme.of(context).platform == TargetPlatform.iOS
//                          ? Colors.blue
//                          : Colors.white,
//                      child: Text(
//                        "P",
//                        style: TextStyle(fontSize: 40.0),
//                      ),
//                    ),
//                  ),
                  getNavTo("List", All(), context),
                  getNavTo("Add", Add(), context),
//                  getNavTo("Get new ticket", Update(), context)
                ],
              )
  );
}

ListTile getNavTo(String text, page,BuildContext context){
  return  ListTile(
    title: Text(text),
    trailing: Icon(Icons.arrow_forward),
    onTap: (){
      Navigator.of(context).pop();
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 0.5);
          var end = Offset.zero;
          var curve = Curves.elasticOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ));
    },
  );
}