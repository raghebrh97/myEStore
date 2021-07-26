import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_e_store/data/product_reviews_model.dart';

class ProductReviewRepository {
  List<ProductReview> reviews = [];

  Future<List<ProductReview>> getProductReview() async {
    try {
      await FirebaseFirestore.instance
          .collection("product_reviews")
          .get()
          .then((productsReviewsCollection) {
        reviews = productsReviewsCollection.docs.map((reviewsDocument) {
          return ProductReview(
              userName: reviewsDocument['userName'],
              rate: reviewsDocument['rate'],
              comment: reviewsDocument['comment'],
              productName: reviewsDocument['productName']);
        }).toList();
      });
      return reviews;
    } catch (exception) {
      throw (exception);
    }
  }

  Future<ProductReview> submitReview(
      String rate, String comment, String productName) async {

    ProductReview productReview;
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

    try {
      await FirebaseFirestore.instance.collection("product_reviews").add({
        'userName': userName,
        'rate': rate,
        'comment': comment,
        'productName': productName,
      }).then((value) {
        productReview = ProductReview(
            userName: userName,
            rate: rate,
            comment: comment,
            productName: productName,);
      });
    } catch (e) {
      print(e.message);
    }

    return productReview;
  }
}
