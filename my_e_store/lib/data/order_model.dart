import 'package:flutter/cupertino.dart';

import 'cart_model.dart';

class Order {
  List<CartItem> cartItems;
  String state;
  String region;
  String street;
  String buildingNo;
  String phoneNo;
  double totalPrice;
  String dateTime;
  String orderStatus;

  Order(
      {@required this.cartItems,
      @required this.state,
      @required this.region,
      @required this.street,
      @required this.buildingNo,
      @required this.phoneNo ,
      @required this.totalPrice,
      @required this.dateTime,
        @required this.orderStatus
      });
}
