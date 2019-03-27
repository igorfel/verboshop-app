import 'style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verboshop/theme/style.dart';
import 'package:verboshop/components/Buttons/textButton.dart';
import 'package:verboshop/components/Buttons/roundedButton.dart';
import 'package:verboshop/components/TextFields/inputField.dart';

import 'package:verboshop/blocs/blocProvider.dart';
import 'package:verboshop/blocs/authBloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  SignUpPageState createState() => new SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
    Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.only(left: 16.0, right: 16.0),
            decoration: new BoxDecoration(image: backgroundImage),
            height: screenSize.height,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Container(
                    //height: screenSize.height / 2.5,
                    child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Hero(
                        tag: 'VSDove',
                        child: new Image(
                          image: logo,
                          width: (screenSize.width < 500)
                              ? 150.0
                              : (screenSize.width / 4),
                          height: screenSize.height / 4,
                        )),
                    new Text(
                      'CRIAR NOVA CONTA',
                      textAlign: TextAlign.center,
                      style: headingStyle,
                    )
                  ],
                )),
                new Container(
                  //height: screenSize.height / 1.5,
                  child: new Column(
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          usernameField(bloc),
                          emailField(bloc),
                          passwordField(bloc),
                          submitButton(bloc, screenSize),
                        ],
                      ),
                      new TextButton(
                        buttonName: 'Termos e Condições',
                        onPressed: () {},
                        buttonTextStyle: buttonTextStyle,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget usernameField(bloc) {
    return StreamBuilder(
      stream: bloc.username,
      builder: (context, snapshot) {
        return InputField(
            hintText: 'Usuário',
            obscureText: false,
            textInputType: TextInputType.text,
            textStyle: textStyle,
            icon: Icons.person_outline,
            iconColor: Colors.white,
            bottomMargin: 20.0,
            onChanged: bloc.changeUsername,
            errorText: snapshot.error);
      },
    );
  }

  Widget emailField(bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return new InputField(
            hintText: 'Email',
            obscureText: false,
            textInputType: TextInputType.emailAddress,
            textStyle: textStyle,
            icon: Icons.mail_outline,
            iconColor: Colors.white,
            bottomMargin: 20.0,
            onChanged: bloc.changeEmail,
            errorText: snapshot.error);
      },
    );
  }

  Widget passwordField(bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return new InputField(
            hintText: 'Senha',
            obscureText: true,
            textInputType: TextInputType.text,
            textStyle: textStyle,
            icon: Icons.lock_open,
            iconColor: Colors.white,
            bottomMargin: 40.0,
            onChanged: bloc.changePassword,
            errorText: snapshot.error);
      },
    );
  }

  Widget submitButton(bloc, screenSize) {
    return StreamBuilder(
      stream: bloc.submitValidNewAccount,
      builder: (context, snapshot) {
        bool enabled = snapshot.data == true ? true : false;

        return StreamBuilder(
            stream: bloc.validLogin,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data['valid'] == true) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
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
                      buttonName: 'Confirmar',
                      width: screenSize.width,
                      height: 50.0,
                      bottomMargin: 10.0,
                      borderWidth: 1.0,
                      borderColor: enabled ? Colors.grey : Colors.white,
                      textColor: enabled ? Colors.grey : Colors.white,
                      onTap: enabled ? bloc.signUp : null);
            });
      },
    );
  }
}
