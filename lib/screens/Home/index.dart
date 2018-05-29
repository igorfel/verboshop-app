import "package:flutter/material.dart";
import "style.dart";
import 'package:verboshop/services/authentication.dart';
import 'package:verboshop/services/audiosManager.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({ Key key }) : super(key: key);

@override
HomeScreenState createState() => new HomeScreenState();

}

class HomeScreenState extends State<HomeScreen>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserAuth userAuth = new UserAuth();
  AudiosManager audiosManager = new AudiosManager();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSignOut() {
    userAuth.signOut().then((onValue) {
      if(onValue == "Logout Successfull"){
        Navigator.pushNamedAndRemoveUntil(context, "/Login", (_) => false);
      } else {
        showInSnackBar(onValue);
      }
    }).catchError((e) {
      showInSnackBar(e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
            title: new Text('VERBOSHOP'),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.redo),
                tooltip: 'SAIR',
                onPressed: _handleSignOut,
              ),
            ],
          ),
      body:new Center(
        child:
          new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            itemCount: audiosManager.listOfAudios.length,
            itemExtent: 80.0,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                //leading: const Icon(Icons.flight_land),
                title: new Row(
                  children: <Widget>[
                    new Expanded(child: new Text('Ministração $index')),
                    new IconButton(
                      icon: const Icon(Icons.play_arrow),
                      tooltip: 'Ouvir ministração',
                      onPressed: () { print("buscando " + audiosManager.listOfAudios[index].url); },
                    ),
                  ],
                ),
                subtitle: Text('Ministro: ' + audiosManager.listOfAudios[index].minister),
                //onTap: () { /* react to the tile being tapped */ }
              );
            },
          )
      )
    );
  }
}