import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verboshop/theme/style.dart';
import 'style.dart';
import 'package:verboshop/components/TextFields/inputField.dart';
import 'package:verboshop/components/Buttons/textButton.dart';
import 'package:verboshop/components/Buttons/roundedButton.dart';
import 'package:verboshop/services/validations.dart';
import 'package:verboshop/services/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
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
    print("button clicked");
  }

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = formKey.currentState;

    _toggleHandler();

    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      _toggleHandler();
      showInSnackBar('Por favor, corrija os erros antes de prosseguir.');
    } else {
      form.save();
      userAuth.verifyUser(user).then((onValue) {
        if (onValue == "Login Successfull") {
          Navigator.pushReplacementNamed(context, "/HomePage");
        } else {
          showInSnackBar(onValue);
        }
      }).catchError((e) {
        showInSnackBar(e.message);
      }).whenComplete(() {
        _toggleHandler();
      });
    }
  }

  void _toggleHandler() {
    setState(() {
      if (isHandlingLogin)
        isHandlingLogin = false;
      else
        isHandlingLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());
    Validations validations = new Validations();
    return new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
            controller: scrollController,
            child: new Container(
              padding: new EdgeInsets.all(16.0),
              decoration: new BoxDecoration(image: backgroundImage),
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: screenSize.height / 2,
                    child: new Column(

                      children: <Widget>[
                        new Hero(
                            tag: 'VSDove',
                            child: new Image(
                          image: logo,
                          width: (screenSize.width < 500)
                              ? 270.0
                              : (screenSize.width / 4) + 32.0,
                          height: screenSize.height / 4 + 80,
                        ))
                      ],
                    ),
                  ),
                  new Container(
                    height: screenSize.height / 2,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Form(
                          key: formKey,
                          autovalidate: autovalidate,
                          child: new Column(
                            children: <Widget>[
                              new InputField(
                                  hintText: "Usuário",
                                  obscureText: false,
                                  textInputType: TextInputType.emailAddress,
                                  textStyle: textStyle,
                                  //textFieldColor: Colors.white,
                                  icon: Icons.mail_outline,
                                  iconColor: Colors.white,
                                  bottomMargin: 20.0,
                                  validateFunction: validations.validateEmail,
                                  onSaved: (String email) {
                                    user.email = email;
                                  }),
                              new InputField(
                                  hintText: "Senha",
                                  obscureText: true,
                                  textInputType: TextInputType.text,
                                  textStyle: textStyle,
                                  // textFieldColor: textFieldColor,
                                  icon: Icons.lock_open,
                                  iconColor: Colors.white,
                                  bottomMargin: 30.0,
                                  validateFunction:
                                      validations.validatePassword,
                                  onSaved: (String password) {
                                    user.password = password;
                                  }),
                              (isHandlingLogin) ? 
                                new CircularProgressIndicator(
                                  value: null,
                                  strokeWidth: 4.0,
                                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                              ) : new RoundedButton(
                                buttonName: "Entrar",
                                onTap: _handleSubmitted,
                                width: screenSize.width,
                                height: 50.0,
                                bottomMargin: 10.0,
                                borderWidth: 0.0,
                                buttonColor: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new TextButton(
                                buttonName: "Criar conta",
                                onPressed: () => onPressed("/SignUp"),
                                buttonTextStyle: buttonTextStyle),
                            new TextButton(
                                buttonName: "Informações",
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
}
