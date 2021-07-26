import 'package:flutter/material.dart';
import 'package:my_e_store/data/cart_model.dart';

class CartItemDetails extends StatefulWidget {
  static const cartDetailsRoute = '/cartDetailsRoute';
  var data;
  CartItemDetails(this.data);

  @override
  _CartItemDetailsState createState() => _CartItemDetailsState();
}

class _CartItemDetailsState extends State<CartItemDetails> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Order Details'),),
        body: SingleChildScrollView(
          child : Container(
            alignment: Alignment.center,
              child: Card(
                  elevation: 5,
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  margin: EdgeInsets.all(15),
                  child: IgnorePointer(
                    child: DataTable(
                        dataRowHeight: MediaQuery.of(context).size.height * 0.15,
                        dataTextStyle: TextStyle(
                            color: Colors.blueGrey, fontWeight: FontWeight.bold),
                        headingRowColor:
                        MaterialStateProperty.all(Theme.of(context).primaryColor),
                        headingTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        columns: [
                          DataColumn(
                            label: Text('Product'),
                          ),
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Price')),
                        ],
                        rows: [
                          ...(widget.data['model'][widget.data['index']].cartItems as List<CartItem>)
                              .map((cartItem) {
                            return DataRow(
                                cells: [
                              DataCell(Text(
                                '${cartItem.name}',
                              )),
                              DataCell(Text(
                                'x${cartItem.quantity}',
                              )),
                              DataCell(
                                Text(
                                  '${cartItem.price}',
                                ),
                              ),
                            ]);
                          }).toList(),
                          DataRow(cells: [
                            DataCell(Text('')),
                            DataCell(
                              Text(
                                'Total : ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15),
                              ),
                            ),
                            DataCell(Text('${widget.data['model'][widget.data['index']].totalPrice}'))
                          ])
                        ],
                      ),
                    ),
                  )),
            ),
          );
  }
}
