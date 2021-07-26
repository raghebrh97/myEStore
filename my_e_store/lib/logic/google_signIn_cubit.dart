import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_e_store/data/users_repository.dart';
import 'package:my_e_store/logic/general_states.dart';

class GoogleCubit extends Cubit<GeneralStates>{
  UsersRepository usersRepository;
  GoogleCubit(this.usersRepository) : super(InitialState());

  Future<void> signInWithGoogle() async {
    emit(LoadingState());
    try {
      var user = await usersRepository.signInWithGoogle();
      emit(LoadedState(user));
    } on FirebaseException catch (e) {
      emit(ErrorState(e.message));
      throw FirebaseException(
          message: e.message, code: e.code, plugin: e.plugin);
    }

  }
}