import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_e_store/data/products_repos.dart';
import 'package:my_e_store/data/produtcs_model.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:collection/collection.dart';

class ProductsCubit extends HydratedCubit<GeneralStates>{

  ProductsRepository productsRepository;
  ProductsCubit(this.productsRepository):super(InitialState());
  List<Product> prodList;
  Map<String , List<Product>> filteredMap;


  Future<void> getProductsDetails() async {
    try {
      emit(LoadingState());
      prodList =  await productsRepository.getProducts();
      emit(LoadedState(prodList));
      filterListByCategory();
    } catch (e){
      emit(ErrorState(e.toString()));
      print(e.message);
      throw(e);
    }
  }

  void filterListByCategory(){
    prodList.sort((a , b){
      return a.categoryId.compareTo(b.categoryId);
    });
    filteredMap = groupBy(prodList, (Product product)=> product.categoryId);
  }

  Map<String ,List<Product>> get filteredMapGetter{
    return filteredMap;
  }

  @override
  GeneralStates fromJson(Map<String, dynamic> json) {
    return LoadedState(json['productsList']);
  }

  @override
  Map<String, dynamic> toJson(GeneralStates state) {
    if(state is LoadedState){
      String jsonList = jsonEncode(state.model);
      return {'productsList' : jsonList};
    }
    return null;
  }

}