
import 'dart:io';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite/sqlite_api.dart';
import 'package:http/http.dart' as http;

import 'Recipe.dart';
import 'Util.dart';

class Repository extends ControllerMVC {
  factory Repository() {
    if (_this == null) {
      _this = Repository._();
    }
    return _this;
  }

  static Database _database;

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();

    return _database;
  }

  static Repository _this;

  Repository._();

  static Repository get repo => _this;

  String DATABASE_NAME = "Database.db";
  String LOCAL = "local_table";
  String CACHE = 'CACHE';
  Util util = new Util();
  bool adding = false;
  String ADD = '/recipe';
  String GET = 'recipes/asd';
  String DELETE = '/recipe';
  String UPDATE = '/recipe';

  final String host = "10.0.2.2";
  final int port = 2201;


  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = directory.path + 'database.db';
    var database = openDatabase(
        dbPath, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
//    _onUpgrade(await db, 0, 1);
    return database;
  }

  void _onCreate(Database db, int version) {
    db?.execute(
        "CREATE TABLE IF NOT EXISTS $LOCAL"+util.getDBStructure());
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE IF EXISTS $LOCAL");
    db.execute("DROP TABLE IF EXISTS $CACHE");
    _onCreate(db, newVersion);
    print("Database was upgraded!");
  }

  void add(Recipe entity) async {
    if(!(await ping())) {
      var mdb = await db;
      mdb?.execute("DROP TABLE IF EXISTS $CACHE");
      mdb?.execute(
          "CREATE TABLE IF NOT EXISTS $CACHE"+util.getCacheDBStructure());

      mdb.insert(CACHE, util.toMapForDb(entity));
      return;
    }

    var uri = Uri.http(
        host + ":" + port.toString(), ADD);

    Future<http.Response> future = http.post(uri,body: util.toMapForServer(entity));

  }

  Future<bool> ping()async{
//    token= await UserService.service.getToken();
    var uri = Uri.http(
        host + ":" + port.toString(), "/recipes/beginner");

    Future<http.Response> future = http.get(uri);


    try{
      future=future.timeout(Duration(seconds: 3));
      var resp= await future;

      allAdder();

      return resp.statusCode==200;
    }
    catch(e){
      return false;
    }


  }

  Future<void> allAdder() async {
    if(adding)
      return;
    adding=true;
    var client = await db;
    try{
      final Future<List<Map<String, dynamic>>> futureMaps =client.rawQuery("SELECT * FROM $CACHE",null);
      var maps = await futureMaps;
      if (maps.length != 0) {
        maps.forEach((m)=>{
          adder(util.fromDb(m))
        });
        client.execute("DROP TABLE IF EXISTS $CACHE");
      }
    }
    catch(e){

    }
    adding=false;
    return;
  }

  Future<void> adder(Recipe entity) async {
    var uri = Uri.http(
        host + ":" + port.toString(), ADD,util.toMapForServer(entity));

    Future<http.Response> future = http.post(uri);
  }

  Future<List<Recipe>> getAll()async{
    if(!(await ping()))
      return getAll_local();

    var uri = Uri.http(
        host + ":" + port.toString(), GET);

    Future<http.Response> future = http.get(uri);

    var resp= await future;
    if(resp.statusCode!=200)
      throw http.ClientException(resp.body);

    var mdb = await db;

    if(resp.body=='[]') {
      mdb.execute("DROP TABLE IF EXISTS $LOCAL");
      mdb.execute("CREATE TABLE IF NOT EXISTS $LOCAL"+util.getDBStructure());
      throw "The list is empty!";
    }

    var result = resp.body.replaceAll("[", "").replaceAll("]", "").split("},")
        .map((str)=>str.split("}")[0])
        .map((str)=>util.fromJson(str+"}")
    ).toList();



    mdb.execute("DROP TABLE IF EXISTS $LOCAL");
    mdb.execute("CREATE TABLE IF NOT EXISTS $LOCAL"+util.getDBStructure());

    result.forEach((entity)=>add_local(entity));

    return result;
  }

  Future<List<Recipe>> getAll_local() async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =client.rawQuery("SELECT * FROM $LOCAL",null);
    var maps = await futureMaps;
    if (maps.length != 0) {
      List<Recipe> res= new List<Recipe>();
      maps.forEach((m)=>{
        res.add(util.fromDb(m))
      });
      return res;
    }
    return null;
  }

  void add_local(Recipe entity) async {
    var client = await db;
    client.insert(LOCAL,util.toMapForDb(entity));
  }

  void remove(id) async {
  if(!(await ping()))
  throw http.ClientException("Can't connect to Server!");

  var uri = Uri.http(
  host + ":" + port.toString(), DELETE+'/'+id.toString());

  Future<http.Response> future = http.delete(uri);

  }

  void update(Recipe entity)  async {
    if(!(await ping()))
      throw http.ClientException("Can't connect to Server!");

    var uri = Uri.http(
        host + ":" + port.toString(), UPDATE+'/'+entity.id.toString());

    Future<http.Response> future = http.put(uri,body: util.toMapForServer(entity));
  }
}