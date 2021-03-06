import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verboshop/theme/style.dart';
import 'style.dart';
import 'package:verboshop/components/TextFields/inputField.dart';
import 'package:verboshop/components/Buttons/textButton.dart';
import 'package:verboshop/components/Buttons/roundedButton.dart';
import 'package:verboshop/services/validations.dart';
import 'package:verboshop/services/authentication.dart';

import 'package:verboshop/blocs/blocProvider.dart';
import 'package:verboshop/blocs/authBloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  BuildContext context;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  UserData user = new UserData();
  UserAuth userAuth = new UserAuth();
  bool autovalidate = false;
  bool isHandlingLogin = false;
  Validations validations = new Validations();

  _onPressed() {
    print('button clicked');
  }

  navigateTo(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value ?? 'Erro desconhecido')));
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
            controller: scrollController,
            child: new Container(
              height: screenSize.height,
              padding: new EdgeInsets.all(16.0),
              decoration: new BoxDecoration(image: backgroundImage),
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: screenSize.height / 2.5,
                    child: new Column(
                      children: <Widget>[
                        new Hero(
                            tag: 'VSDove',
                            child: new Image(
                              image: logo,
                              width: (screenSize.width < 500)
                                  ? 170.0
                                  : (screenSize.width / 4) + 32.0,
                              height: screenSize.height / 4 + 80,
                            ))
                      ],
                    ),
                  ),
                  new Container(
                    child: new Column(
                      children: <Widget>[
                        new Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: <Widget>[
                                  usernameField(bloc),
                                  passwordField(bloc),
                                ],
                              ),
                            ),
                            submitButton(bloc, screenSize),
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new TextButton(
                                buttonName: 'Criar conta',
                                onPressed: () =>
                                    Navigator.of(context).pushNamed('/SignUp'),
                                buttonTextStyle: buttonTextStyle),
                            new TextButton(
                                buttonName: 'Informações',
                                onPressed: _onPressed,
                                buttonTextStyle: buttonTextStyle)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  Widget usernameField(bloc) {
    return StreamBuilder(
      stream: bloc.username,
      builder: (context, snapshot) {
        return InputField(
            hintText: 'Usuário',
            obscureText: false,
            textStyle: textStyle,
            icon: Icons.person_outline,
            iconColor: Colors.white,
            bottomMargin: 20.0,
            onChanged: bloc.changeUsername,
            errorText: snapshot.error);
      },
    );
  }

  Widget passwordField(bloc) {
    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {
          return InputField(
              hintText: 'Senha',
              obscureText: true,
              textInputType: TextInputType.text,
              textStyle: textStyle,
              icon: Icons.lock_open,
              iconColor: Colors.white,
              bottomMargin: 30.0,
              onChanged: bloc.changePassword,
              errorText: snapshot.error);
        });
  }

  Widget submitButton(bloc, screenSize) {
    return StreamBuilder(
        stream: bloc.submitValidAccount,
        builder: (context, snapshot) {
          bool enabled = snapshot.data == true ? true : false;

          return StreamBuilder(
              stream: bloc.validLogin,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data['valid'] == true) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.pushReplacementNamed(context, '/HomePage');
                  });
                }
                return (snapshot.hasData && snapshot.data['requesting'] == true)
                    ? CircularProgressIndicator(
                        value: null,
                        strokeWidth: 4.0,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(primaryColor),
                      )
                    : RoundedButton(
                        buttonName: 'Entrar',
                        width: screenSize.width,
                        height: 50.0,
                        bottomMargin: 10.0,
                        borderWidth: 0.0,
                        textColor: enabled ? Colors.white : Colors.grey,
                        buttonColor:
                            enabled ? primaryColor : disabledPrimaryColor,
                        onTap: enabled ? bloc.signIn : null);
              });
        });
  }
}
