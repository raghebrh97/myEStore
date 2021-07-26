import 'package:my_e_store/data/user_model.dart';
import 'package:my_e_store/data/users_repository.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';


class UsersCubit extends HydratedCubit<GeneralStates> {
  UsersRepository usersRepository;
  UsersCubit(this.usersRepository) : super(InitialState());
  UserModel newUser;

  Future<void> userAuthenticate(
      {String name, String email, String password, bool isLogin}) async {
    try {
      emit(LoadingState());
       newUser =
          await usersRepository.authenticate(email, name, password, isLogin);
      emit(LoadedState(newUser));
      print(newUser.email);
    } on FirebaseException catch (e) {
      emit(ErrorState(e.message));
      throw FirebaseException(
          message: e.message, code: e.code, plugin: e.plugin);
    }
  }

  Future<void> signUserOut() async{
    await usersRepository.signOut();
  }

  @override
  GeneralStates fromJson(Map<String, dynamic> json) {
   return LoadedState(UserModel(email: json['email'] , name: json['userName'] , password: json['password']));
  }

  @override
  Map<String, dynamic> toJson(GeneralStates state) {
    if(state is LoadedState)
      return {'email' : state.model.email , 'userName' : state.model.name , 'password' : state.model.password};
    return null;
  }

}
