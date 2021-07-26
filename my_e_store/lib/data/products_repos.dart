import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_e_store/data/produtcs_model.dart';

class ProductsRepository {
  List<Product> products = [];

  var fireStoreInstance = FirebaseFirestore.instance.collection("products");

  Future<List<Product>> getProducts() async {
    try {
      await fireStoreInstance.get().then((productsCollection) {
        products = productsCollection.docs.map((productsDocument) {
          return Product(
              productName: productsDocument.id,
              categoryId: productsDocument['categoryId'].toString().trim(),
              productImages: productsDocument['imagesUrls'],
              description: productsDocument['description'],
              price: double.parse(productsDocument['price']),
              quantity: double.parse(productsDocument['quantity']));
        }).toList();
      });
    } catch (exception) {
      throw (exception);
    }
    return products;
  }

}
