import 'package:flutter/material.dart';
import 'package:verboshop/pages/Login/index.dart';
import 'package:verboshop/pages/SignUp/index.dart';
import 'package:verboshop/pages/Home/index.dart';
import 'package:verboshop/theme/style.dart';

import 'blocs/blocProvider.dart';
import 'blocs/authBloc.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/Login": (BuildContext context) => new LoginPage(),
    "/SignUp": (BuildContext context) => new SignUpPage(),
    "/HomePage": (BuildContext context) => new HomePage()
  };

  Routes() {
    runApp(BlocProvider<AuthBloc>(
        bloc: AuthBloc(),
        child: MaterialApp(
          title: "Verboshop",
          home: new LoginPage(),
          theme: appTheme,
          routes: routes,
        )));
  }
}
