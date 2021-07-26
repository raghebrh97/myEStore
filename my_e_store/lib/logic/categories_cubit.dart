import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_e_store/data/category_model.dart';
import 'package:my_e_store/data/categories_repos.dart';
import 'package:my_e_store/logic/general_states.dart';

class CategoriesCubit extends HydratedCubit<GeneralStates>{
  CategoriesRepo categoriesRepo;
  CategoriesCubit(this.categoriesRepo) : super(InitialState());
  List<Category> category;


  Future<void> readCategoriesData() async{
    try {
      emit(LoadingState());
      category = await categoriesRepo.getCategories();
      emit(LoadedState(category));
    } on FirebaseException catch(e){
      emit(ErrorState(e.message));
      throw(FirebaseException(message: e.message , code: e.code , plugin: e.plugin));
    }
  }

  List<Category> get getCategoryList{
    return category;
  }

  @override
  GeneralStates fromJson(Map<String, dynamic> json) {
    return LoadedState(json['categoriesList']);
  }

  @override
  Map<String, dynamic> toJson(GeneralStates state) {
    if(state is LoadedState){
      String jsonList = jsonEncode(state.model);
      return {'categoriesList' : jsonList};
    }
    return null;
  }

  List<Category> get catList{
    return category;
  }

}