import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_e_store/data/order_model.dart';
import 'cart_model.dart';

class OrdersRepository {
  List<Order> userOrders = [];
  List<CartItem> cartItems = [];

  Future<Order> submitOrder(
      List<CartItem> cartItems,
      String state,
      String region,
      String street,
      String building,
      String phone,
      double totalPrice,
      String dateTime) async {
    Order order;
    String currentUserEmail = FirebaseAuth.instance.currentUser.email;
    var firebaseUserInstance = FirebaseFirestore.instance.collection('users');
    String userName;

    await firebaseUserInstance
        .where('email', isEqualTo: currentUserEmail)
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        userName = doc['userName'];
      });
    });

    final map2 = Map<String, Map<String, dynamic>>();
    for (int i = 0; i < cartItems.length; i++) {
      map2.putIfAbsent(
          '$i',
          () => {
                'name': cartItems[i].name,
                'quantity': cartItems[i].quantity,
                'price': cartItems[i].price
              });
    }

    try {
      await FirebaseFirestore.instance.collection("orders").add({
        'userName': userName,
        'email': currentUserEmail,
        'state': state,
        'region': region,
        'street': street,
        'buildingNo': building,
        'phoneNo': phone,
        'cartDetails': map2,
        'totalPrice': double.parse(totalPrice.toStringAsFixed(2)),
        'dateTime' : dateTime,
        'status' : 'Submitted'
      }).then((value) {
        order = Order(
            cartItems: cartItems,
            state: state,
            region: region,
            street: street,
            buildingNo: building,
            phoneNo: phone,
            totalPrice: double.parse(totalPrice.toStringAsFixed(2)),
          dateTime: dateTime
        );
      });
    } catch (e) {
      print(e.message);
    }

    return order;
  }

  Future<List<Order>> fetchUserOrders() async {
     await FirebaseFirestore.instance.collection('orders').orderBy('dateTime' , descending: true)
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser.email).get()
          .then((ordersCollection) {
        userOrders = ordersCollection.docs.map((orderDoc) {
          cartItems = (orderDoc['cartDetails'] as Map<String,dynamic>).values.map((e) {
           return  CartItem(e['name'], e['quantity'], e['price']);
          }).toList();

          return Order(
              cartItems: cartItems,
              state: orderDoc['state'],
              region: orderDoc['region'],
              street: orderDoc['street'],
              buildingNo: orderDoc['buildingNo'],
              phoneNo: orderDoc['phoneNo'],
              totalPrice: orderDoc['totalPrice'],
            dateTime: orderDoc['dateTime'],
            orderStatus: orderDoc['status']
          );
        }).toList();

      });

    return userOrders;
  }
}
