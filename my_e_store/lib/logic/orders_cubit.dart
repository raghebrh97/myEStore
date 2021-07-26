import 'package:bloc/bloc.dart';
import 'package:my_e_store/data/cart_model.dart';
import 'package:my_e_store/data/order_model.dart';
import 'package:my_e_store/data/order_repository.dart';
import 'package:my_e_store/logic/general_states.dart';

class OrdersCubit extends Cubit<GeneralStates>{
  OrdersRepository ordersRepository;
  OrdersCubit(this.ordersRepository):super(InitialState());
  Order order;
  List<Order> userOrders = [];

  Future<Order> submitUserOrder(List<CartItem> cartItems, String state,
      String region, String street, String building, String phone , double totalPrice , String dateTime) async{
    emit(LoadingState());
    try {
      order = await ordersRepository.submitOrder(
          cartItems, state, region, street, building, phone , totalPrice , dateTime);
      emit(LoadedState(order));
      emit(InitialState());
    } catch(e){
      emit(ErrorState(e.message));
    }
    return order;
  }

  Future<void> fetchOrders() async {
      emit(InitialState());
      emit(LoadingState());
      try {
        userOrders = await ordersRepository.fetchUserOrders();
        emit(LoadedState(userOrders));
      } catch(e){
        print(e);
        emit(ErrorState(e.message));
      }
  }


}