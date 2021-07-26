import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_e_store/data/category_model.dart';

class CategoriesRepo {

  var fireStoreInstance = FirebaseFirestore.instance.collection("categories");
  List<Category> catList = [];

  Future<List<Category>> getCategories() async{
      await fireStoreInstance.get().then((categoriesCollection) {
        catList = categoriesCollection.docs.map((categoryDoc) {
         return Category(name: categoryDoc.id , imgUrl:  categoryDoc['imgUrl'] , categoryId: categoryDoc['categoryId']);
       }).toList();
     });

    return catList;
  }

  List<Category> get categoryList{
    return catList;
  }

}