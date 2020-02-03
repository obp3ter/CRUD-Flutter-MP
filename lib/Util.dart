import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reflectable/reflectable.dart';

import 'Recipe.dart';
import 'do_reflect.dart';
import 'dart:convert';

class Util{

  ClassMirror getMirror(){
    Recipe instance = new Recipe('a','a',1,'a',1);
    InstanceMirror instanceMirror = myReflectable.reflect(instance);
    ClassMirror mirror = myReflectable.reflectType(Recipe);
    return mirror;
  }

  Map<String,String> getMap()
  {
    ClassMirror mirror = getMirror();

    Map<String,String> result = new Map();

    mirror.declarations.forEach((f,v) => {
      if(v.runtimeType.toString().startsWith("Var"))
        result[v.simpleName]=(v as VariableMirror).reflectedType.toString()
    });



    return result;

  }

  String getDBStructure(){
    return getMap().toString().replaceAll(':','')
        .replaceAll('String','TEXT').replaceAll('int','INTEGER').toUpperCase()
        .replaceAll('{','(').replaceAll('}',')')
        .replaceAll('ID INTEGER','ID INTEGER PRIMARY KEY');
  }
  String getCacheDBStructure(){
    return getDBStructure().replaceAll('PRIMARY KEY', 'PRIMARY KEY AUTO INCREMENT');
  }

  Map<String,dynamic> toMapForServer(Recipe instance){
    var map = Map<String, dynamic>();
    InstanceMirror instanceMirror = myReflectable.reflect(instance);
    getMap().keys.forEach((key) => map[key]=instanceMirror.invokeGetter(key).toString());

    if(map['id']=='null')
      map.remove('id');

    return map;
  }
  Map<String,dynamic> toMapForInternal(Recipe instance){
    var map = Map<String, dynamic>();
    InstanceMirror instanceMirror = myReflectable.reflect(instance);
    getMap().keys.forEach((key) => map[key]=instanceMirror.invokeGetter(key));

    if(map['id']=='null')
      map.remove('id');

    return map;
  }

  Map<String,dynamic> toMapForDb(Recipe instance){
    var map = Map<String, dynamic>();
    InstanceMirror instanceMirror = myReflectable.reflect(instance);
    getMap().keys.forEach((key) => {if(key!='id')map[key.toUpperCase()]=instanceMirror.invokeGetter(key)});
    return map;
  }

  Recipe fromDb(Map<String, dynamic> map){
  var res = Recipe.empty();
  InstanceMirror instanceMirror = myReflectable.reflect(res);
  getMap().forEach((k,v)=>{if(k!='id')instanceMirror.invokeSetter(k, map[k.toUpperCase()])});
  return res;
  }

  Recipe fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    var res = Recipe.empty();
    InstanceMirror instanceMirror = myReflectable.reflect(res);
    getMap().forEach((k,v)=>{
      if(v=='String')
        instanceMirror.invokeSetter(k, map[k]),
      if(v=='int')
        if(map[k].runtimeType.toString()=='int')
          instanceMirror.invokeSetter(k, map[k])
        else
          instanceMirror.invokeSetter(k, int.parse(map[k]))
      ,
      if(v=='double')
        if(map[k].runtimeType.toString()=='double')
          instanceMirror.invokeSetter(k, map[k])
        else
          instanceMirror.invokeSetter(k, double.parse(map[k]))
    });
    return res;
  }

  Recipe fromInternal(Map<String, dynamic> map){
    var res = Recipe.empty();
    InstanceMirror instanceMirror = myReflectable.reflect(res);
    getMap().forEach((k,v)=>{if(k!='id')instanceMirror.invokeSetter(k, map[k])});
    return res;
  }

  String toBeautifulString(Recipe instance){
    String result = '';
    InstanceMirror instanceMirror = myReflectable.reflect(instance);
    getMap().keys.forEach((key) => result+=key+': '+instanceMirror.invokeGetter(key).toString()+' ');
    return result;
  }
  String toBeautifulStringWithoutID(Recipe instance){
    String result = '';
    InstanceMirror instanceMirror = myReflectable.reflect(instance);
    getMap().keys.forEach((key) => {if(key!='id')result+=key+': '+instanceMirror.invokeGetter(key).toString()+' '});
    return result;
  }



}