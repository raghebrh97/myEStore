import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:my_e_store/logic/orders_cubit.dart';
import 'package:my_e_store/screens/cartItem_details_screen.dart';

class OrderStatusScreen extends StatefulWidget {
  static const String ordersStatusRoute = '/ordersStatusRoute';
  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  void initState() {
    BlocProvider.of<OrdersCubit>(context).fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        title: Text('My Orders'),
      ),
      body: BlocBuilder<OrdersCubit, GeneralStates>(builder: (ctx, state) {
        if (state is LoadingState)
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );
        else if (state is LoadedState) {
          if (state.model.length > 0) {
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return Column(children: [
                  ListTile(
                    //tileColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => CartItemDetails(
                              {'model': state.model, 'index': index}),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 200),
                        ),
                      );
                    },
                    //'${DateFormat('EEEE').format(${state.model[index].dateTime})} , ${DateFormat('d/M/y').format(${state.model[index].dateTime})}'
                    trailing: FittedBox(
                        child: Row(children: [
                      Text('${state.model[index].orderStatus}'),
                      Icon(
                        Icons.chevron_right,
                      )
                    ])),
                    leading: Container(
                        height: double.infinity,
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.blueGrey,
                        )),
                    title: Text(
                        '${DateFormat('EEEE').format(DateTime.parse(state.model[index].dateTime))} , ${DateFormat('d/M/y').format(DateTime.parse(state.model[index].dateTime))}'),
                    subtitle:
                        Text('Total : ${state.model[index].totalPrice} JOD'),
                  ),
                  Divider(
                    thickness: 0.5,
                  )
                ]);
              },
              itemCount: state.model.length,
            );
          } else
            return Center(
              child: Text('You have made no orders yet'),
            );
        } else
          return Center(
            child: Text('You have made no orders yet'),
          );
      }),
    );
  }
}
