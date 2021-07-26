import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_e_store/data/category_model.dart';
import 'package:my_e_store/data/search_delegate.dart';
import 'package:my_e_store/logic/cart_cubit.dart';
import 'package:my_e_store/logic/categories_cubit.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:my_e_store/logic/products_cubit.dart';
import 'package:my_e_store/screens/categories_screen.dart';
import 'package:my_e_store/screens/products_screen.dart';
import 'package:my_e_store/widgets/app_drawer.dart';
import 'package:my_e_store/widgets/products_list_widget.dart';

import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  static const homeScreenRoute = '/homeScreenRoute';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _controller;
  Timer scrollTimer;
  List<Category> categoriesList = [];

  @override
  void initState() {
    _controller = ScrollController();

    try {
      BlocProvider.of<CategoriesCubit>(context).readCategoriesData();
    } catch (e) {
      print(e.message);
    }

    scrollTimer = Timer.periodic(Duration(seconds: 5), (t) {
      if (_controller.offset < _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        _controller.animateTo(
            _controller.offset + MediaQuery.of(context).size.width,
            curve: Curves.linear,
            duration: Duration(milliseconds: 750));
      } else {
        _controller.animateTo(_controller.position.minScrollExtent,
            curve: Curves.linear, duration: Duration(milliseconds: 1000));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var devSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(
                  context: context,
                  delegate: CustomSearchClass(
                      BlocProvider.of<ProductsCubit>(context).prodList))),
          TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.cartScreenRoute);
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              label:
                  BlocBuilder<CartCubit, GeneralStates>(builder: (ctx, state) {
                if (state is LoadedState) {
                  return Text(
                    '${(state.model as Map<String, dynamic>)['cartList'].length.toString()}',
                    style: TextStyle(color: Colors.white),
                  );
                } else
                  return Text('0', style: TextStyle(color: Colors.white));
              })),
        ],
        title: Text('Home'),
      ),
      body: BlocBuilder<CategoriesCubit, GeneralStates>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadedState) {
            categoriesList = state.model as List<Category>;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.blueGrey))),
                      width: double.infinity,
                      child: ListView.builder(
                        cacheExtent: state.model.length *
                            devSize.width,
                        controller: _controller,
                        itemCount: state.model.length,
                        scrollDirection: Axis.horizontal,
                        itemExtent: devSize.width,
                        physics: PageScrollPhysics(),
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                            child: Stack(children: [
                              ClipRRect(
                                  child: CachedNetworkImage(
                                imageUrl: state.model[i].imgUrl,
                                memCacheHeight:
                                    (devSize.height * 0.25)
                                        .toInt(),
                                memCacheWidth:
                                devSize.width.toInt(),
                                width: devSize.width,
                                fit: BoxFit.cover,
                                placeholder: (ctx, url) =>
                                    // Icon(Icons.image ,size: 130,),
                                    Image.asset(
                                    'assets/images/placeholder1.jpg',
                                    width: devSize.width,
                                    cacheWidth: devSize.width.toInt() ,
                                    //height: devSize.height,
                                    fit: BoxFit.cover),
                              )),
                              Align(
                                child: Container(
                                  child: Text(
                                    state.model[i].name,
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
                                  arguments: {
                                    'categoryId': state.model[i].name
                                  });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ProductsListWidget(),
                    flex: 3,
                  ),
                  Align(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(CategoriesScreen.categoriesRoute);
                      },
                      child: Text(
                        'All Categories',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(devSize.width, 50)),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                  )
                ]);
          } else if (state is ErrorState) {
            return Center(
              child: Text(
                  'Error : Issue while trying to communicate with the Server',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          } else
            return Center(child: Text('There are not Items'));
        },
      ),
      drawer: Drawer(
        child: MyAppDrawer(),
        elevation: 5,
      ),
    );
  }
}
