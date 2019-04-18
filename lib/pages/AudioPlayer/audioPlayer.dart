import 'dart:math';

import 'package:audioplayers_with_rate/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';
import 'package:verboshop/models/audio.dart';
import 'package:verboshop/theme/style.dart';

enum PlayerState { stopped, playing, paused }

class AudioPlayerPage extends StatefulWidget {
  final Audio _audioData;
  final AudioPlayer _audioPlayer;

  AudioPlayerPage(this._audioData, this._audioPlayer);

  @override
  _AudioPlayerState createState() =>
      new _AudioPlayerState(_audioData, _audioPlayer);
}

class _AudioPlayerState extends State<AudioPlayerPage> {
  final FirebaseApp _app = FirebaseApp.instance;
  FirebaseStorage _storage;
  final Audio _audio;
  final AudioPlayer _player;
  PlayerState _playerState = PlayerState.stopped;
  double _thumbPercent = 0;
  Duration _duration;
  Duration _position;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;

  _AudioPlayerState(this._audio, this._player);

  @override
  void initState() {
    super.initState();

    _storage = FirebaseStorage(
        app: _app, storageBucket: 'gs://verboshop-app.appspot.com');
  }

  Widget _buildRadialSeekBar() {
    return RadialSeekBar(
      trackColor: Colors.red.withOpacity(.5),
      trackWidth: 2.0,
      progressColor: primaryColor,
      progressWidth: 5.0,
      thumbPercent: _thumbPercent,
      thumb: CircleThumb(
        color: primaryColor,
        diameter: 20.0,
      ),
      progress: _thumbPercent,
      onDragUpdate: (double percent) {
        setState(() {
          _thumbPercent = percent;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Verbo Store",
              style: TextStyle(color: primaryColor, fontFamily: "Nexa")),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Center(
                child: Container(
                  width: 250.0,
                  height: 250.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(.5),
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _buildRadialSeekBar(),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipOval(
                              clipper: MClipper(),
                              child: Image.asset(
                                "assets/vsdove.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Column(
                children: <Widget>[
                  Text(
                    _audio.title,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 20.0,
                        fontFamily: "Nexa"),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    _audio.author,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 18.0,
                        fontFamily: "NexaLight"),
                  )
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                width: 350.0,
                height: 150.0,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 65.0,
                        width: 290.0,
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 3.0),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.fast_rewind,
                                  size: 55.0, color: primaryColor),
                              Expanded(
                                child: Container(),
                              ),
                              Icon(Icons.fast_forward,
                                  size: 55.0, color: primaryColor)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 92.0,
                        height: 92.0,
                        decoration: BoxDecoration(
                            color: primaryColor, shape: BoxShape.circle),
                        child: _isPlaying
                            ? IconButton(
                                icon: Icon(
                                  Icons.pause,
                                  size: 45.0,
                                  color: Colors.white,
                                ),
                                onPressed: _pause,
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.play_arrow,
                                  size: 45.0,
                                  color: Colors.white,
                                ),
                                onPressed: _play,
                              ),
                      ),
                    )
                  ],
                ),
              ),
              // Container(
              //   height: 190.0,
              //   width: double.infinity,
              //   child: Stack(
              //     children: <Widget>[
              //       Positioned(
              //         left: -25,
              //         child: Container(
              //           width: 50.0,
              //           height: 190.0,
              //           decoration: BoxDecoration(
              //               color: primaryColor,
              //               borderRadius: BorderRadius.only(
              //                   topRight: Radius.circular(30.0),
              //                   bottomRight: Radius.circular(30.0))),
              //         ),
              //       ),
              //       Positioned(
              //         right: -25,
              //         child: Container(
              //           width: 50.0,
              //           height: 190.0,
              //           decoration: BoxDecoration(
              //               color: primaryColor,
              //               borderRadius: BorderRadius.only(
              //                   topLeft: Radius.circular(30.0),
              //                   bottomLeft: Radius.circular(30.0))),
              //         ),
              //       ),
              //       Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             song("assets/cover_01.jpg", "Never say",
              //                 "Believe 2012"),
              //             song("assets/cover_02.jpg", "Beauty...",
              //                 "Believe 2012"),
              //             song("assets/cover_03.png", "Boyfriend",
              //                 "Believe 2012"),
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ));
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final url = await _storage
        .ref()
        .child('ministracoes')
        .child(_audio.url)
        .getDownloadURL();
    final result =
        await _player.play(url, position: playPosition ?? Duration.zero);
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    return result;
  }

  Future<int> _pause() async {
    final result = await _player.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }
}

Widget song(String image, String title, String subtitle) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/vsdove.png',
          width: 40.0,
          height: 40.0,
        ),
        SizedBox(
          width: 8.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(color: primaryColor)),
            Text(subtitle, style: TextStyle(color: primaryColor))
          ],
        )
      ],
    ),
  );
}

class MClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
