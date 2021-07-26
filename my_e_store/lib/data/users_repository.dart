import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_e_store/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersRepository{

  final fbAuth = FirebaseAuth.instance;

  Future<UserModel> authenticate(
      String email, String userName, String password, bool isLogin) async {

      isLogin
          ? await fbAuth.signInWithEmailAndPassword(
          email: email.toString().toLowerCase(), password: password)
          : await fbAuth
          .createUserWithEmailAndPassword(
          email: email.toString().toLowerCase(), password: password)
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(value.user.uid)
            .set({
          'email': email,
          'userName': userName,
        }).catchError((error) {
          print(error);
        });
      });

    return UserModel(name: userName, email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    UserCredential userCred;
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

       userCred = await FirebaseAuth.instance
          .signInWithCredential(credential);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user.uid)
          .set({
        'email': userCred.user.email,
        'userName': userCred.user.displayName,
      }).catchError((error) {
        print(error);
      });
    } catch(error){
      print(error.message);
    }

   return userCred;
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}