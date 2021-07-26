import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_e_store/logic/users_cubit.dart';
import 'package:my_e_store/screens/cart_screen.dart';
import 'package:my_e_store/screens/categories_screen.dart';
import 'package:my_e_store/screens/order_status_screen.dart';
import 'package:my_e_store/screens/splash_screen.dart';
import 'package:my_e_store/screens/user_auth_screen.dart';
import 'package:standard_dialogs/classes/dialog_action.dart';
import 'package:standard_dialogs/dialogs/result_dialog.dart';

class MyAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: Container(),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(CartScreen.cartScreenRoute);
            },
            title: Text('Cart'),
            leading: Icon(Icons.shopping_cart),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(CategoriesScreen.categoriesRoute);
            },
            title: Text('Categories'),
            leading: Icon(Icons.category_outlined),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(OrderStatusScreen.ordersStatusRoute);
            },
            title: Text('Track Your Orders'),
            leading: Icon(Icons.attach_money),
          ),
          ListTile(
            onTap: () async {
              showSuccessDialog(context,
                  content: Column(
                    children: [
                      FittedBox(
                        child: TextButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.email_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            label: Text(
                              'raghebrh97@gmail.com',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                      FittedBox(
                        child: TextButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.phone_in_talk,
                                color: Theme.of(context).primaryColor),
                            label: Text(
                              '+962 795394511',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  icon: Icon(Icons.contact_phone_outlined) , action: DialogAction(title: Text('Dismiss')));
            },
            title: Text('Contact us'),
            leading: Icon(Icons.contact_support_outlined),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(MySplashScreen.splashRoute);
              BlocProvider.of<UsersCubit>(context).signUserOut().then((value) {
                Navigator.of(context)
                    .pushReplacementNamed(UserAuthScreen.userAuthRoute);
              });
            },
            title: Text('Logout'),
            leading: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
