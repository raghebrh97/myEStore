import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:my_e_store/data/produtcs_model.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:my_e_store/logic/products_cubit.dart';
import 'package:my_e_store/screens/product_details.dart';
import 'package:my_e_store/screens/products_screen.dart';

class ProductsListWidget extends StatefulWidget {
  @override
  _ProductsListWidgetState createState() => _ProductsListWidgetState();
}

class _ProductsListWidgetState extends State<ProductsListWidget> {
  Map<String, List<Product>> filteredMap;
  List<Product> prodList = [];

  @override
  void initState() {
    try {
      BlocProvider.of<ProductsCubit>(context)
          .getProductsDetails()
          .whenComplete(() {
        filteredMap = BlocProvider.of<ProductsCubit>(context).filteredMap;
        //prodList = BlocProvider.of<ProductsCubit>(context).prodList;

        if(mounted) {
          filteredMap.forEach((key, value) {
            value.forEach((element) {
              DefaultCacheManager().downloadFile(
                  element.productImages[0], force: true).then((_) {});
            });
          });
        }

      });
    } catch (exception) {
      print(exception.message.toString());
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, GeneralStates>(
      builder: (context, state) {
        if (state is LoadingState)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (state is LoadedState) {
          return Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: ListView.builder(
                cacheExtent: 5 * (MediaQuery.of(context).size.height * 0.40),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        filteredMap.keys.toList()[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 125,
                        child: ListView.builder(
                          cacheExtent:
                              5 * (MediaQuery.of(context).size.width * 0.30),
                          itemCount:
                              filteredMap.values.toList()[index].length > 5
                                  ? 5
                                  : filteredMap.values.toList()[index].length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, i) {
                            return Row(children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ProductDetails.detailsRoute,
                                      arguments: filteredMap.values
                                          .toList()[index][i]);
                                },
                                child: Card(
                                  //borderRadius: BorderRadius.circular(5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child:
                                      CachedNetworkImage(
                                          imageUrl: filteredMap.values
                                              .toList()[index][i]
                                              .productImages[0],
                                          memCacheHeight: 700,
                                          //memCacheWidth: 450,
                                          fit: BoxFit.fill,
                                          placeholder: (ctx, url) =>
                                             Icon(Icons.image_outlined ,size: 75,),
                                            //   Image.asset(
                                            //     'assets/images/placeholder2.png',
                                            //     fit: BoxFit.contain,
                                            //     //cacheWidth: 75,
                                            //     //cacheHeight: 120,
                                            //     width: 75,
                                            //     height: 120,
                                            //   )
                                      )
                                      ),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              )
                            ]);
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          child: Text(
                            'More Products',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                ProductsScreen.productsScreenRoute,
                                arguments: {
                                  'categoryId': filteredMap.keys.toList()[index]
                                });
                          },
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                        ),
                      ),
                      Divider(
                        color: Colors.white70,
                      ),
                    ],
                  );
                  // );
                },
              ));
        } else if (state is ErrorState)
          return Center(
            child: Text(
                'Error : Issue while trying to communicate with the Server',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          );
        else
          return Center(
              child: Text(
            'There are not Items',
            style: TextStyle(color: Colors.white),
          ));
      },
    );
  }
}
