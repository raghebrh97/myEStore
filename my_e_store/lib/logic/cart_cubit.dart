import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_e_store/data/cart_model.dart';
import 'package:my_e_store/data/produtcs_model.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartCubit extends HydratedCubit<GeneralStates> {
  List<Product> cartItems = [];
  Map<String, List<Product>> finalCart = {};
  List<CartItem> cartProducts = [];
  List<Product> testList = [];

  CartCubit() : super(InitialState());

  void addItemsToCart(Product item) {
    emit(LoadingState());
    cartItems.add(item);
    getFinalCart();
    if (cartItems.isNotEmpty)
      emit(LoadedState({'cartList': cartItems, 'cartMap': finalCart}));
    else
      emit(InitialState());
  }

  void removeItemsFromCart(Product item) {
    emit(LoadingState());
    cartItems.remove(item);
    if(cartItems.isEmpty){
      clearCart();
    }
    getFinalCart();

    if (cartItems.isNotEmpty)
      emit(LoadedState({'cartList': cartItems, 'cartMap': finalCart}));
    else
      emit(InitialState());
  }

  Map<String, List<Product>> getFinalCart() {
    cartItems.sort((a, b) {
      return a.productName.trim().compareTo(b.productName.trim());
    });
    return finalCart =
        groupBy(cartItems, (Product product) => product.productName.trim());
  }

  List<CartItem> get cartItemsFilter {
    cartProducts.clear();

    finalCart.forEach((key, value) {
      cartProducts
          .add(CartItem(key, value.length, value[0].price * value.length));
    });

    return cartProducts;
  }

  double getTotalPrice() {
    double finalPrice = 0.0;
    cartItems.forEach((element) {
      finalPrice += element.price;
    });
    return finalPrice;
  }

  void clearCart() {
    cartProducts.clear();
    cartItems.clear();
    finalCart.clear();
    testList.clear();
    HydratedCubit.storage.clear();
    emit(InitialState());
  }

  Future<void> saveCartToDevice() async {
    var data = jsonEncode({'cartList': cartItems, 'cartMap': finalCart});
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('cart', data);
  }

  @override
  GeneralStates fromJson(Map<String, dynamic> json) {
    var myData = jsonDecode(json['cart']);

    (myData['cartList'] as List<dynamic>).forEach((value) {
      testList.add(Product(
          productName: value['name'],
          categoryId: value['categoryId'],
          productImages: value['images'],
          description: value['description'],
          price: value['price'],
          quantity: value['quantity']));
    });

    testList.sort((a, b) {
      return a.productName.trim().compareTo(b.productName.trim());
    });
    cartItems = testList;
    return LoadedState({'cartList': cartItems, 'cartMap': getFinalCart()});
  }

  @override
  Map<String, dynamic> toJson(GeneralStates state) {
    if (state is LoadedState) {
      String jsonList = jsonEncode(state.model);
      return {'cart': jsonList};
    }
    return null;
  }

}
