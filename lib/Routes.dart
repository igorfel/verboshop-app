import 'package:flutter/material.dart';
import 'package:verboshop/pages/Login/index.dart';
import 'package:verboshop/pages/SignUp/index.dart';
import 'package:verboshop/pages/Home/index.dart';
import 'package:verboshop/theme/style.dart';

import 'blocs/blocProvider.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/Login": (BuildContext context) => new LoginPage(),
    "/SignUp": (BuildContext context) => new SignUpPage(),
    "/HomePage": (BuildContext context) => new HomePage()
  };

  Routes() {
    runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider<>()
      );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Verboshop",
      home: new HomePage(),
      theme: appTheme,
      routes: routes,
    )
  }
}