import 'dart:async';

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

  // int currentPlaying = -1, lastPlayingIndex = -1;
  // Duration lastDuration, lastPosition;
  // String currentTitle, currentContent;

  UserAuth userAuth = new UserAuth();
  AudiosManager audiosManager = new AudiosManager();

  // LocalNotifications localNotifications;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSignOut() {
    userAuth.signOut().then((onValue) {
      if(onValue == "Logout Successfull"){
        audiosManager.stop();
        //_cancelNotification();
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
                icon: new Icon(Icons.power_settings_new),
                tooltip: 'SAIR',
                onPressed: _handleSignOut,
              ),
            ],
          ),
      body: new AudioList(audiosManager),
    );
  }
}

// new Center(
//         child:
//           new ListView.builder(
//             padding: new EdgeInsets.all(8.0),
//             itemCount: audiosManager.listOfAudios.length,
//             itemExtent: 80.0,
//             itemBuilder: (BuildContext context, int index) {
//               return new ListTile(
//                 //leading: const Icon(Icons.flight_land),
//                 title: new Row(
//                   children: <Widget>[
//                     new Expanded(child: new Text(audiosManager.listOfAudios[index].title)),
//                     new IconButton(
//                       icon: (audiosManager.currentPlaying == index && !showPlayIcon) ? new Icon(Icons.pause) : new Icon(Icons.play_arrow),
//                       tooltip: 'Ouvir/pausar ministração',
//                       onPressed: (audiosManager.currentPlaying == index && !showPlayIcon) ? () => _pauseAudio() : () => _playAudio(index),

//                     ),
//                   ],
//                 ),
//                 subtitle: Text('Ministro: ' + audiosManager.listOfAudios[index].minister),
//                 //onTap: () { /* react to the tile being tapped */ }
//               );
//             },
//           )
//  )