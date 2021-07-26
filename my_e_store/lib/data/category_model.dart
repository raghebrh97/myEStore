import 'package:flutter/cupertino.dart';

class Category {
  String name;
  String imgUrl;
  String categoryId;

  Category({@required this.name , @required this.imgUrl , this.categoryId});

  Map toJson() => {
    'name': name,
    'categoryId': categoryId,
    'images' : imgUrl
  };
}