import 'package:flutter/cupertino.dart';

class Product {
  String productName;
  String categoryId;
  List<dynamic> productImages;
  String description;
  double price;
  double quantity;

  Product(
      {@required this.productName,
      @required this.categoryId,
      @required this.productImages,
      @required this.description,
      @required this.price,
      @required this.quantity});

  Map toJson() =>
      {'name': productName, 'categoryId': categoryId, 'images': productImages , 'description' : description , 'price' : price , 'quantity' : quantity};
}
