import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_e_store/data/product_reviews_model.dart';
import 'package:my_e_store/data/produtcs_model.dart';
import 'package:my_e_store/logic/cart_cubit.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:my_e_store/logic/product_reviews_cubit.dart';
import 'package:my_e_store/screens/cart_screen.dart';
import 'package:my_e_store/screens/user_reviews_screen.dart';

class ProductDetails extends StatefulWidget {
  static const detailsRoute = '/productDetails';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var imageIndex = 0;
  Map<String, List<ProductReview>> reviewsList = {};
  double productRate = 0.0;
  Product product;

  @override
  void didChangeDependencies() {
    product = ModalRoute.of(context).settings.arguments as Product;
    BlocProvider.of<ProductReviewsCubit>(context)
        .getProductReviews()
        .whenComplete(() {
          if(mounted) {
            setState(() {
              productRate = BlocProvider.of<ProductReviewsCubit>(context)
                  .getProductRate(product);
            });
          }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
          actions: [
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.cartScreenRoute);
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                label: BlocBuilder<CartCubit, GeneralStates>(
                    builder: (ctx, state) {
                  if (state is LoadedState) {
                    return Text(
                      '${(state.model as Map<String, dynamic>)['cartList'].length.toString()}',
                      style: TextStyle(color: Colors.white),
                    );
                  } else
                    return Text('0', style: TextStyle(color: Colors.white));
                }))
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          height: deviceSize.height,
          width: deviceSize.width,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                product.productName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Align(
                  child: IconButton(
                      color: imageIndex == 0 ? Colors.black26 : Colors.black,
                      iconSize: 30,
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          if (imageIndex > 0 &&
                              imageIndex < product.productImages.length)
                            imageIndex -= 1;
                        });
                      }),
                  alignment: Alignment.centerLeft,
                ),
                Expanded(
                  flex: 2,
                  child: CachedNetworkImage(
                    fadeInCurve: Curves.easeIn,
                    imageUrl: product.productImages[imageIndex],
                    height: 200,
                    width: 150,
                    fit: BoxFit.contain,
                    placeholder: (ctx, url) => Image.asset(
                      'assets/images/loading7.gif',
                      fit: BoxFit.contain,
                      width: 150,
                      height: 200,
                      cacheHeight: 200,
                      cacheWidth: 150,
                    ),
                  ),
                ),
                Align(
                  child: IconButton(
                      iconSize: 30,
                      color: imageIndex == product.productImages.length - 1
                          ? Colors.black26
                          : Colors.black,
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          if (imageIndex >= 0 &&
                              imageIndex < product.productImages.length - 1)
                            imageIndex += 1;
                        });
                      }),
                  alignment: Alignment.centerRight,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      FittedBox(
                          child: RatingBar(
                        ignoreGestures: true,
                        initialRating: productRate.isNaN ? 0.0 : productRate,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                          ),
                          half: Icon(
                            Icons.star_half,
                            color: Colors.orangeAccent,
                          ),
                          empty: Icon(
                            Icons.star_border_outlined,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        //itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FittedBox(
                        child: Text(
                          '${product.price} JOD',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromRGBO(3, 54, 105, 0.7),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<CartCubit>(context)
                              .addItemsToCart(product);
                        },
                        child: BlocBuilder<CartCubit, GeneralStates>(
                            builder: (ctx, state) {
                          if (state is LoadingState)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else if (state is LoadedState) {
                            var cartBloc = BlocProvider.of<CartCubit>(context);
                            var cartList = state.model['cartList'];
                            var cartMap = state.model['cartMap'] as Map<String , List<Product>>;
                            return FittedBox(
                              child: Row(
                                children: [
                                  if (cartMap[product.productName.trim()]?.isNotEmpty ??false)
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          cartBloc.addItemsToCart(
                                              cartList.firstWhere((element) {
                                            return element.productName.trim() ==
                                                product.productName.trim();
                                          }));
                                        }),
                                  FittedBox(
                                    child: Text((cartMap[product.productName.trim()]
                                                ?.isEmpty ??
                                            true)
                                        ? 'Add to Cart'
                                        : cartMap[product.productName.trim()]
                                            ?.length
                                            .toString()),
                                  ),
                                  if (cartMap[product.productName.trim()]?.isNotEmpty ??false)
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          cartBloc.removeItemsFromCart(
                                              cartList.firstWhere((element) {
                                            return element.productName.trim() ==
                                                product.productName.trim();
                                          }));
                                        }),
                                ],
                              ),
                            );
                          } else {
                            return FittedBox(child: Text('Add to Cart'));
                          }
                        }),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(3, 54, 105, 0.7)),
                          minimumSize: MaterialStateProperty.all(
                              Size(deviceSize.width * 0.35, 40)),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                product.description.trim(),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        UserReviewsScreen.reviewsRoute,
                        arguments: product);
                  },
                  child: Text(
                    'Check Users Reviews!',
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Colors.blueAccent),
                      minimumSize: MaterialStateProperty.all(Size(
                          deviceSize.width * 0.5, deviceSize.height * 0.05))),
                ),
              )
            ]),
          ),
        ));
  }
}
