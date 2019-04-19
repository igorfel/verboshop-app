import 'package:flutter/material.dart';
import 'package:verboshop/blocs/authBloc.dart';
import 'package:verboshop/blocs/blocProvider.dart';

class AccountPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _stateKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Index 2: Account'),
          FlatButton(
            child: Text('Sair'),
            onPressed: () => _handleSignOut(context),
          )
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    _stateKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSignOut(context) {
    final AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
    bloc.signOut();

    bloc.validLogin.listen((data) {
      if (data['signOut'] == true)
        Navigator.pushNamedAndRemoveUntil(context, '/Login', (_) => false);
      else
        showInSnackBar(data['message']);
    });
  }
}
