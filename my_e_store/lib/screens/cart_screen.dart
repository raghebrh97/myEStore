import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_e_store/data/produtcs_model.dart';
import 'package:my_e_store/logic/cart_cubit.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:my_e_store/widgets/checkout_widget.dart';

class CartScreen extends StatefulWidget {
  static const String cartScreenRoute = '/cartRoute';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var cartBloc = BlocProvider.of<CartCubit>(context);
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('My Cart')),
      body: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        child: BlocBuilder<CartCubit, GeneralStates>(builder: (ctx, state) {
          if (state is LoadingState)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (state is LoadedState) {
            var cartList = (state.model['cartList'] as List<Product>);
            var cartMap =
            (state.model['cartMap'] as Map<String, List<Product>>);
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Flexible(
                fit: FlexFit.loose,
                flex: 4,
                child: Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        title: SizedBox(
                            width: deviceSize.width * 0.55,
                            child: Text(
                              cartMap.keys.toList()[index],
                              overflow: TextOverflow.ellipsis,
                            )),
                        trailing: SizedBox(
                          width: deviceSize.width * 0.45,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    cartBloc.addItemsToCart(
                                        cartList.firstWhere((element) {
                                          return element.productName.trim() ==
                                              cartMap.keys.toList()[index];
                                        }));
                                  }),
                              Text(cartMap.values
                                  .toList()[index]
                                  .length
                                  .toString()),
                              IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    cartBloc.removeItemsFromCart(
                                        cartList.firstWhere((element) {
                                          return element.productName.trim() ==
                                              cartMap.keys.toList()[index];
                                        }));
                                  }),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                      '${(cartMap.values.toList()[index][0].price * cartMap.values.toList()[index].length).toStringAsFixed(2)} JOD'),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: cartMap.length,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: ' Total Price : ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                      TextSpan(
                          text:
                          ' ${cartBloc.getTotalPrice().toStringAsFixed(2)} ',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 18)),
                      TextSpan(
                          text: ' JOD ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                    ]),
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (ctx) {
                            return Padding(child: CheckOutWidget() , padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),);
                          });
                      //Navigator.of(context).pushNamed(CheckOutWidget.checkOutRoute);
                    },
                    child: Text('Proceed to Checkout'),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                        shadowColor: MaterialStateProperty.all(Colors.black),
                        elevation: MaterialStateProperty.all(10),
                        minimumSize: MaterialStateProperty.all(Size(
                            deviceSize.width * 0.82, deviceSize.height * 0.05)),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor))),
              ),
            ]);
          } else {
            return Center(
              child: Text('Your cart is empty!',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          }
        }),
      ),
    );
  }
}
