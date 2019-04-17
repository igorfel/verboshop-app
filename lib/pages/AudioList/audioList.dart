import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AudioList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      icon: Icon(Icons
                          .play_arrow), //(audiosManager.currentPlaying == document['url'] && !showPlayIcon) ? new Icon(Icons.pause) : new Icon(Icons.play_arrow),
                      tooltip: 'Ouvir/pausar ministração',
                      onPressed:
                          () {} //(audiosManager.currentPlaying == document['url'] && !showPlayIcon) ? () => _pauseAudio() : () => _playAudio(document),

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
