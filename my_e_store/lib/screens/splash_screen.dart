import 'package:flutter/material.dart';

class MySplashScreen extends StatelessWidget {
  static const splashRoute = '/splashRoute';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              'Loading...',
              style:
                  TextStyle(color: Theme.of(context).textTheme.headline6.color),
            ),
          )),
    );
  }
}
