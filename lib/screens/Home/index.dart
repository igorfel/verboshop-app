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
  bool showPlayIcon = true;
  // int currentPlaying = -1, lastPlayingIndex = -1;
  // Duration lastDuration, lastPosition;
  // String currentTitle, currentContent;

  UserAuth userAuth = new UserAuth();
  //AudiosManager audiosManager = new AudiosManager();

  // LocalNotifications localNotifications;

  int _selectedIndex = 1;
  final _widgetOptions = [
    Text('Index 0: Home'),
    Text('Index 1: Search'),
    Container(child: Column(children: <Widget>[Text('Index 2: Account')],),)
  ];

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSignOut() {
    userAuth.signOut().then((onValue) {
      if(onValue == "Logout Successfull"){
        //audiosManager.stop();
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

    // audiosManager.audioPlayer.completionHandler = () {
    //   audiosManager.complete();

    //   setState(() { showPlayIcon = true; });
    // };

    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
            title: new Text('VERBOSHOP'),
          ),
      body:   Center(
       child: _widgetOptions.elementAt(_selectedIndex),
     ),
     bottomNavigationBar: BottomNavigationBar(
       items: <BottomNavigationBarItem>[
         BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Início')),
         BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Procurar')),
         BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('Conta')),
       ],
       currentIndex: _selectedIndex,
       fixedColor: Colors.red[900],
       onTap: _onItemTapped,
     ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index == 2){
        _handleSignOut();
      }
    });
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