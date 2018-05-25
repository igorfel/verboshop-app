import 'package:flutter/material.dart';
import 'package:verboshop/screens/Login/index.dart';
import 'package:verboshop/screens/SignUp/index.dart';
import 'package:verboshop/screens/Home/index.dart';
import 'package:verboshop/theme/style.dart';

class Routes {

  var routes = <String, WidgetBuilder>{
    "/Login": (BuildContext context) => new LoginScreen(),
    "/SignUp": (BuildContext context) => new SignUpScreen(),
    "/HomePage": (BuildContext context) => new HomeScreen()
  };

  Routes() {
    runApp(new MaterialApp(
      title: "Verboshop",
      home: new LoginScreen(),
      theme: appTheme,
      routes: routes,
    ));
  }
}
