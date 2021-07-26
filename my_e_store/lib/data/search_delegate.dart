import 'package:flutter/material.dart';
import 'package:my_e_store/data/produtcs_model.dart';
import 'package:my_e_store/screens/product_details.dart';

class CustomSearchClass extends SearchDelegate {
  List<dynamic> searchResult = [];
  List<dynamic> myList;

  CustomSearchClass(this.myList);

  List<dynamic> searchConditions(List<dynamic> list) {
    list = myList.where((element) {
      if (myList is List<Product>) {
        return (element.productName.contains(query) ||
            element.description.contains(query) ||
            element.productName.toString().toLowerCase().contains(query) ||
            element.description.toString().toLowerCase().contains(query) ||
            element.productName.toString().toUpperCase().contains(query) ||
            element.description.toString().toUpperCase().contains(query));
      } else
        return false;
    }).toList();

    return list;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
// this will show clear query button
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
// adding a back button to close the search
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchResult.clear();

    searchResult = searchConditions(myList);

    if (searchResult.isEmpty)
      return Center(
        child: Text('No results found'),
      );
    else {
      return ProductsSearchWidget(searchResult);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchResult = searchConditions(myList);

    if (searchResult.isEmpty)
      return Center(
        child: Text('No results found'),
      );
    else if (query.isNotEmpty && searchResult.isNotEmpty) {
      return ProductsSearchWidget(searchResult);
    } else
      return Container();
  }
}

class ProductsSearchWidget extends StatelessWidget {
  final List searchResult;
  ProductsSearchWidget(this.searchResult);

  @override
  Widget build(BuildContext context) {
    return (searchResult?.isEmpty ?? true)
        ? Center(
            child: Text(
              'There are not Items!',
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
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProductDetails.detailsRoute,
                        arguments: searchResult[index]);
                  },
                  child: Card(
                      elevation: 1,
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.all(5),
                      child: Container(
                        height: 120,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                    searchResult[index].productImages[0],
                                    width: 80,
                                    //height: 150,
                                    // memCacheHeight: 200,
                                    // memCacheWidth: 150,
                                    fit: BoxFit.fill),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          searchResult[index]
                                              .productName
                                              .trim(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          searchResult[index]
                                              .description
                                              .trim(),
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
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    ProductDetails.detailsRoute,
                                                    arguments:
                                                        searchResult[index]);
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
            ));
  }
}
