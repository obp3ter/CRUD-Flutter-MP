import 'do_reflect.dart';

@myReflectable
class Recipe{
  int id;
  String name;
  String details;
  int time;
  String type;
  int rating;

  Recipe.withID(this.id, this.name, this.details, this.time, this.type, this.rating);

  Recipe(this.name, this.details, this.time, this.type, this.rating);

  Recipe.empty();

}