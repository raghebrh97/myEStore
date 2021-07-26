import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_e_store/logic/cart_cubit.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:my_e_store/logic/orders_cubit.dart';
import 'package:standard_dialogs/standard_dialogs.dart';

class CheckOutWidget extends StatefulWidget {
  static const String checkOutRoute = '/checkOutRoute';
  @override
  _CheckOutWidgetState createState() => _CheckOutWidgetState();
}

class _CheckOutWidgetState extends State<CheckOutWidget> {
  var formKey = GlobalKey<FormState>();
  String state, region, street, building, phone;

  void submitForm() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      String dateTime = DateTime.now().toIso8601String();
      await BlocProvider.of<OrdersCubit>(context)
          .submitUserOrder(
              BlocProvider.of<CartCubit>(context).cartItemsFilter,
              state,
              region,
              street,
              building,
              phone,
              BlocProvider.of<CartCubit>(context).getTotalPrice(),
          dateTime)
          .whenComplete(() {
        BlocProvider.of<CartCubit>(context).clearCart();
        Navigator.pop(context);
        Navigator.pop(context);
        showSuccessDialog(context,
            title: Text('Order Status'),
            content: Text('Your order was submitted successfully'),
            action: DialogAction(
              title: Text('Dismiss'),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Shipping Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: 'State/Governorate',
              ),
              textInputAction: TextInputAction.next,
              onSaved: (text) {
                state = text;
              },
              validator: (text) {
                if (text.isEmpty || text.length < 4)
                  return 'Please enter a valid value';
                else
                  return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Region'),
              textInputAction: TextInputAction.next,
              onSaved: (text) {
                region = text;
              },
              validator: (text) {
                if (text.isEmpty || text.length < 4)
                  return 'Please enter a valid value';
                else
                  return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Street Address'),
              textInputAction: TextInputAction.next,
              onSaved: (text) {
                street = text;
              },
              validator: (text) {
                if (text.isEmpty || text.length < 4)
                  return 'Please enter a valid value';
                else
                  return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Building Number'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onSaved: (text) {
                building = text;
              },
              validator: (text) {
                if (RegExp(r"[\d]", caseSensitive: false).hasMatch(text))
                  return null;
                else
                  return 'Please enter a number only';
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Phone number'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSaved: (text) {
                phone = text;
              },
              validator: (text) {
                if (RegExp(r"^(0)(\d{9})", caseSensitive: false).hasMatch(text))
                  return null;
                else
                  return 'Please a valid mobile number';
              },
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              child: OutlineButton(
                child: BlocBuilder<OrdersCubit, GeneralStates>(
                    builder: (ctx, myStates) {
                  if (myStates is LoadingState) {
                    return SizedBox(
                      width: 15,
                      height: 15,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black87,
                        ),
                      ),
                    );
                  } else if (myStates is LoadedState) {
                    return Text('Submit Order!');
                  } else {
                    return Text('Submit Order!');
                  }
                }),
                onPressed: submitForm,
                textColor: Colors.black,
                color: Colors.black,
                highlightedBorderColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              alignment: Alignment.bottomRight,
            )
          ],
        ),
      ),
    );
  }
}
