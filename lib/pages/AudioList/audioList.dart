import 'package:audioplayers_with_rate/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:verboshop/models/audio.dart';
import 'package:verboshop/pages/AudioPlayer/audioPlayer.dart';

class AudioList extends StatelessWidget {
  final AudioPlayer _audioPlayer;

  AudioList(this._audioPlayer);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('audios').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Carregando...');

        return new ListView(
          padding: new EdgeInsets.all(8.0),
          itemExtent: 80.0,
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            Audio audioData = Audio.fromMap(document.data);

            return new ListTile(
              leading: Image.asset(
                'assets/vsdove.png',
                width: 40.0,
                height: 40.0,
              ),
              title: new Row(
                children: <Widget>[
                  new Expanded(child: new Text(audioData.title)),
                ],
              ),
              subtitle: new Text(audioData.author),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AudioPlayerPage(audioData, _audioPlayer)));
              },
            );
          }).toList(),
        );
      },
    );
  }
}
