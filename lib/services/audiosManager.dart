import 'package:verboshop/models/audio.dart';
import 'package:audioplayers/audioplayer.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_notifications/local_notifications.dart';

class AudiosManager {
  List<Audio> listOfAudios = new List();
  List<DocumentSnapshot> listOfAudiosCloud;

  bool isPlaying = false;
  String currentPlaying = "", lastPlayingIndex = "";
  Duration lastDuration, lastPosition;
  String currentTitle, currentContent;

  AudioPlayer audioPlayer = new AudioPlayer();

  Future play(String url) async {
    if(isPlaying && currentPlaying == url) return;
    
    if(isPlaying || url != lastPlayingIndex)
      audioPlayer.stop();

    final result = await audioPlayer.play(url, isLocal: false);

    if(result == 1) {
      isPlaying = true;
      currentPlaying = url;

      print("Played: " + currentPlaying);
    }
  }

  Future pause() async {
    if(!isPlaying) return;

    final result = await audioPlayer.pause();

    if(result == 1) {
      isPlaying = false;
      lastPlayingIndex = currentPlaying;
      currentPlaying = "";

      print("Paused: " + lastPlayingIndex);
    }
  }
  
  Future resume() async {
    await play(lastPlayingIndex);
  }

  void stop() {
    audioPlayer.stop();
    isPlaying = false;
    currentPlaying = "";
  }

  void complete() {
    isPlaying = false;
    lastPlayingIndex = currentPlaying;
    currentPlaying = "";

    print("Completed: " + currentPlaying);
  }
}

class AudioList extends StatefulWidget {
  AudiosManager audiosManager;

  AudioList(AudiosManager audiosManager){
    this.audiosManager = audiosManager;
  }  

  @override
  AudiosListState createState() => new AudiosListState(audiosManager);
}

class AudiosListState extends State<AudioList> {
  AudiosManager audiosManager;
  bool showPlayIcon = true;

  AudiosListState(AudiosManager audiosManager) {
    this.audiosManager = audiosManager;
  }

  void _playAudio(DocumentSnapshot document) async {
    await audiosManager.play(document['url']);

    _showNotification(document['title'], "Ministro: " + document['author']);

    updateUI();
  }

  static const AndroidNotificationChannel channel = const AndroidNotificationChannel(
    id: '0',
    name: 'CustomNotificationChannel',
    description: 'Grant this app the ability to show notifications',
    importance: AndroidNotificationChannelImportance.LOW,
    vibratePattern: AndroidVibratePatterns.NONE
  );

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
        ],
        androidSettings: new AndroidSettings(
          channel: channel,
          priority: AndroidNotificationPriority.LOW
        )
    );
  }

  Future _cancelNotification() async {
    await LocalNotifications.removeNotification(0);
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

  @override
  Widget build(BuildContext context) {
    audiosManager.audioPlayer.setCompletionHandler(() {
      audiosManager.complete();
      setState(() { showPlayIcon = true; });
    });

    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('audios').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          padding: new EdgeInsets.all(8.0),
          itemExtent: 80.0,
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Row(
                children: <Widget>[
                  new Expanded(child: new Text(document['title'])),
                  new IconButton(
                    icon: (audiosManager.currentPlaying == document['url'] && !showPlayIcon) ? new Icon(Icons.pause) : new Icon(Icons.play_arrow),
                    tooltip: 'Ouvir/pausar ministração',
                    onPressed: (audiosManager.currentPlaying == document['url'] && !showPlayIcon) ? () => _pauseAudio() : () => _playAudio(document),

                  ),
                ],
              ),
              subtitle: new Text("Ministro: " + document['author']),
            );
          }).toList(),
        );
      },
    );
  }
}