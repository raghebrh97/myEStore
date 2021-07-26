import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_e_store/data/category_model.dart';
import 'package:my_e_store/logic/categories_cubit.dart';
import 'package:my_e_store/screens/products_screen.dart';

class CategoriesScreen extends StatefulWidget {
  static const categoriesRoute = '/categoriesRoute';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    List<Category> categoriesList = BlocProvider.of<CategoriesCubit>(context)
        .getCategoryList;

    return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        body: Container(
            child: GridView.builder(
          cacheExtent: categoriesList.length *
              (MediaQuery.of(context).size.height * 0.25),
          padding: EdgeInsets.all(5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 4 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (ctx, i) {
            return GestureDetector(
              child: Stack(children: [
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: categoriesList[i].imgUrl,
                    memCacheHeight:
                        (MediaQuery.of(context).size.height * 0.25).toInt(),
                    memCacheWidth: MediaQuery.of(context).size.width.toInt(),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Image.asset(
                        'assets/images/placeholder.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                Align(
                  child: Container(
                    child: Text(
                      categoriesList[i].name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    color: Color.fromRGBO(00, 00, 00, 0.5),
                    width: double.infinity,
                    height: 35,
                    alignment: Alignment.center,
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ]),
              onTap: () {
                Navigator.of(context).pushNamed(
                    ProductsScreen.productsScreenRoute,
                    arguments: {'categoryId': categoriesList[i].name});
              },
            );
          },
          itemCount: categoriesList.length,
        )));
  }
}
