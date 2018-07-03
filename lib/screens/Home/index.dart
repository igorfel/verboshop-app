import 'dart:async';

import "package:flutter/material.dart";
import "style.dart";
import 'package:verboshop/services/authentication.dart';
import 'package:verboshop/services/audiosManager.dart';

import 'package:local_notifications/local_notifications.dart';

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
        _cancelNotification();
        Navigator.pushNamedAndRemoveUntil(context, "/Login", (_) => false);
      } else {
        showInSnackBar(onValue);
      }
    }).catchError((e) {
      showInSnackBar(e.message);
    });
  }

  void _playAudio(int index) async {
    await audiosManager.play(index);

    _showNotification(audiosManager.listOfAudios[index].title, "Ministro: " + audiosManager.listOfAudios[index].minister);

    updateUI();
  }

  void _pauseAudio() async {
    await audiosManager.pause();

    updateUI();
  }

  void playPauseOnNotification(String payload) async {
    if(audiosManager.isPlaying) {
      await audiosManager.pause();
    } else {
      await audiosManager.resume();
    }

    updateUI();
  }

  void updateUI() {
    if(audiosManager.isPlaying){
      setState(() { showPlayIcon = false; });
    } else {
      setState(() { showPlayIcon = true; });
    }
  }

  Future _showNotification(String title, String content) async {
    await LocalNotifications.createNotification(
        title: title,
        content: content,
        id: 0,
        actions: [
            new NotificationAction(
                actionText: "Pausar/Reproduzir",
                callback: playPauseOnNotification,
                payload: "",
                launchesApp: false
            )
        ]
    );
  }

  Future _cancelNotification() async {
    await LocalNotifications.removeNotification(0);
  }

  @override
  Widget build(BuildContext context) {

    audiosManager.audioPlayer.setCompletionHandler(() {
      audiosManager.complete();

      setState(() { showPlayIcon = true; });
    });

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
                    new Expanded(child: new Text(audiosManager.listOfAudios[index].title)),
                    new IconButton(
                      icon: (audiosManager.currentPlaying == index && !showPlayIcon) ? new Icon(Icons.pause) : new Icon(Icons.play_arrow),
                      tooltip: 'Ouvir/pausar ministração',
                      onPressed: (audiosManager.currentPlaying == index && !showPlayIcon) ? () => _pauseAudio() : () => _playAudio(index),

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