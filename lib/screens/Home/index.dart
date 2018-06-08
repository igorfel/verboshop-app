import 'dart:async';

import "package:flutter/material.dart";
import "style.dart";
import 'package:verboshop/services/authentication.dart';
import 'package:verboshop/services/audiosManager.dart';
import 'package:audioplayers/audioplayer.dart';

import 'package:local_notifications/local_notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key key }) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isPlaying = false;
  int currentPlaying = -1, lastPlayingIndex = -1;
  Duration lastDuration, lastPosition;
  String currentTitle, currentContent;

  UserAuth userAuth = new UserAuth();
  AudiosManager audiosManager = new AudiosManager();
  AudioPlayer audioPlayer = new AudioPlayer();

  // LocalNotifications localNotifications;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSignOut() {
    userAuth.signOut().then((onValue) {
      if(onValue == "Logout Successfull"){
        audioPlayer.stop();
        Navigator.pushNamedAndRemoveUntil(context, "/Login", (_) => false);
      } else {
        showInSnackBar(onValue);
      }
    }).catchError((e) {
      showInSnackBar(e.message);
    });
  }

  void _playAudio(int index) async {
    if(isPlaying) {
      audioPlayer.pause();
      currentPlaying = -1;
      setState(() { isPlaying = false; });
    } else {
      print("buscando " + audiosManager.listOfAudios[index].url);
      final result = await audioPlayer.play(audiosManager.listOfAudios[index].url, isLocal: false);

      if(result == 1) {
        saveCurrentAudioInfo(index);

        if(lastPlayingIndex == index && lastPosition != null && lastPosition.inSeconds > 0)
          audioPlayer.seek(lastPosition.inSeconds.toDouble());

        setState(() { isPlaying = true; });

        _showNotification(audiosManager.listOfAudios[index].title, "Ministro: " + audiosManager.listOfAudios[index].minister);
      }
    }
  }

  void playPauseOnNotification(String payload){
    _playAudio(lastPlayingIndex);
  }

  void saveCurrentAudioInfo(int index) {
    currentPlaying = index;
    lastPlayingIndex = index;
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
    audioPlayer.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    audioPlayer.setDurationHandler((Duration d) => setState(() {
      lastDuration = d;
    }));

    audioPlayer.setPositionHandler((Duration  p) => setState(() {
      lastPosition = p;
    }));

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
                    new Expanded(child: new Text(audiosManager.listOfAudios[index].title)),
                    new IconButton(
                      icon: (isPlaying && currentPlaying == index) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                      tooltip: 'Ouvir ministração',
                      onPressed: () => _playAudio(index),
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