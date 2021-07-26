import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_e_store/data/search_delegate.dart';
import 'package:my_e_store/logic/products_cubit.dart';
import 'package:my_e_store/screens/product_details.dart';

class ProductsScreen extends StatelessWidget {
  static const String productsScreenRoute = '/productsRoute';

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    var categoryId = arguments['categoryId'];
    var productsList = BlocProvider.of<ProductsCubit>(context, listen: false)
        .filteredMap[categoryId];

    return Scaffold(
        appBar: AppBar(
          title: Text(categoryId),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: ()=> showSearch(context: context , delegate: CustomSearchClass(productsList)))
          ],
        ),
        body: (productsList?.isEmpty ?? true)
            ? Center(
                child: Text(
                  'There are not Items in this category!',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).backgroundColor),
                ),
              )
            : Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 5),
                child: ListView.builder(
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed(ProductDetails.detailsRoute , arguments: productsList[index]);
                      },
                      child: Card(
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.all(5),
                          child: Container(
                            height: 120,
                            child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child:
                                    CachedNetworkImage(
                                        imageUrl: productsList[index].productImages[0],
                                        fit: BoxFit.fill,
                                        memCacheHeight:700,
                                        placeholder: (ctx, url) =>
                                            Image.asset(
                                              'assets/images/loading7.gif',
                                              fit: BoxFit.fill,
                                              width: 75,
                                              height: 120,
                                            )
                                    ),
                                    // Image.network(
                                    //     productsList[index].productImages[0],
                                    //     width: 80,
                                    //     //height: 150,
                                    //     // memCacheHeight: 200,
                                    //     // memCacheWidth: 150,
                                    //     fit: BoxFit.fill),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                productsList[index].productName.trim(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            SizedBox(height: 5,),
                                            Text(
                                              productsList[index].description.trim(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Expanded(
                                              child: Align(
                                                child: TextButton(
                                                  child: Text(
                                                    'View Item',
                                                    style: TextStyle(color: Colors.black54),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pushNamed(ProductDetails.detailsRoute , arguments: productsList[index]);
                                                  },
                                                ),
                                                alignment: Alignment.bottomRight,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ]),
                          )),
                    );
                  },
                )));
  }
}
