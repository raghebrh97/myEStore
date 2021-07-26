import 'package:my_e_store/logic/google_signIn_cubit.dart';
import 'package:my_e_store/logic/users_cubit.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:my_e_store/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAuthScreen extends StatefulWidget {
  static const String userAuthRoute = '/userAuthRoute';
  @override
  _UserAuthScreenState createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  var isLogin = false;
  var isLoading = false;
  var formKey = GlobalKey<FormState>();
  var userNameFocus = FocusNode();
  var passwordFocus = FocusNode();
  var email;
  var userName;
  var password;
  var errorMsg;

  void submitForm() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      try {
        await BlocProvider.of<UsersCubit>(context).userAuthenticate(
            email: email, name: userName, password: password, isLogin: isLogin);
      } on FirebaseException catch (e) {
        errorMsg = e.message;
      }
    }
    //firebase call.
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(children: [
        // Expanded(
        //      flex: isLogin? 3 : 2,
        //      child:
        Flexible(
          flex: isLogin? 3 : 2,
          child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              curve: Curves.fastOutSlowIn,
              color: Theme.of(context).primaryColor,
              height: isLogin ? devHeight / 2 : devHeight / 3,
              width: double.infinity,
              child: Center(
                  child: Text(
                'My E-Store',
                style: TextStyle(
                    fontFamily: 'IndieFlower',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              )),
            ),
        ),
        Expanded(
          flex: isLogin? 3 : 2,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 30),
            height: devHeight / 2,
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.alternate_email)),
                      key: ValueKey('Email'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        email = value;
                      },
                      validator: (inputValue) {
                        if (RegExp(r"^[\w-\.]+@[\w-]+\.[a-zA-Z]+$",
                                caseSensitive: false)
                            .hasMatch(inputValue))
                          return null;
                        else
                          return 'Please enter a valid email address';
                      },
                    ),
                    // if (!isLogin)
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: !isLogin
                          ? TextFormField(
                              key: ValueKey('UserName'),
                              focusNode: userNameFocus,
                              cursorColor: Theme.of(context).primaryColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'User Name',
                                  icon: Icon(Icons.person_outline)),
                              onSaved: (value) {
                                userName = value;
                              },
                              validator: (inputValue) {
                                if (RegExp(r"^[\w\s-\.]+$", caseSensitive: false)
                                    .hasMatch(inputValue))
                                  return null;
                                else
                                  return 'Please enter a valid user name';
                              },
                            )
                          : SizedBox(),
                    ),
                    TextFormField(
                      key: ValueKey('Password'),
                      focusNode: passwordFocus,
                      cursorColor: Theme.of(context).primaryColor,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password', icon: Icon(Icons.lock_open)),
                      onSaved: (value) {
                        password = value;
                      },
                      validator: (inputValue) {
                        if (inputValue.isNotEmpty && inputValue.length > 8)
                          return null;
                        else
                          return 'Please enter a password with minimum of 8 characters';
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: submitForm,
                      child: BlocConsumer<UsersCubit, GeneralStates>(
                        builder: (context, state) {
                          if (state is InitialState) {
                            return isLogin ? Text('Login') : Text('Sign up');
                          } else if (state is LoadingState) {
                            return SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ));
                          }
                          return isLogin ? Text('Login') : Text('Sign up');
                        },
                        listener: (context, state) {
                          if (state is ErrorState) {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text(
                                      'Authentication Failed',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    content: Text(errorMsg),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Dismiss'))
                                    ],
                                  );
                                });
                          } else if (state is LoadedState) {
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.homeScreenRoute);
                          }
                        },
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                          shadowColor: MaterialStateProperty.all(Colors.black),
                          elevation: MaterialStateProperty.all(10),
                          minimumSize: MaterialStateProperty.all(
                              Size(devWidth * 0.82, 36)),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                      child: ElevatedButton(
                        onPressed: () async {
                          await BlocProvider.of<GoogleCubit>(context)
                              .signInWithGoogle();
                        },
                        child: BlocConsumer<GoogleCubit, GeneralStates>(
                          builder: (context, state) {
                            if (state is InitialState) {
                              return Row(
                                children: [
                                  Image.asset(
                                    'assets/images/google_icon.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Sign in with Google!',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              );
                            } else if (state is LoadingState) {
                              return SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.redAccent,
                                    strokeWidth: 1.5,
                                  ));
                            }
                            return Row(
                              children: [
                                Image.asset(
                                  'assets/images/google_icon.png',
                                  width: 25,
                                  height: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Signup with Google!',
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            );
                          },
                          listener: (context, state) {
                            if (state is ErrorState) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text(
                                        'Authentication Failed',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      content: Text(errorMsg),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Dismiss'))
                                      ],
                                    );
                                  });
                            } else if (state is LoadedState) {
                              Navigator.of(context).pushReplacementNamed(
                                  HomeScreen.homeScreenRoute);
                            }
                          },
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                          shadowColor: MaterialStateProperty.all(Colors.black),
                          elevation: MaterialStateProperty.all(5),
                          minimumSize: MaterialStateProperty.all(
                              Size(devWidth * 0.82, 40)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            minimumSize: MaterialStateProperty.all(
                                Size(devWidth * 0.5, 36)),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                        child: isLogin
                            ? Text('Click here to create an account')
                            : Text(
                                'Already have an account? click here to login')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
