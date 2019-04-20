import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:verboshop/blocs/blocProvider.dart';

enum PlayerState { stopped, playing, paused }

class AudioBloc extends BlocBase {
  FirebaseApp _app = FirebaseApp.instance;
  FirebaseStorage _storage;
  AudioPlayer _audioPlayer;

  final _positionSubject = BehaviorSubject<Duration>();
  final _playerCompleteSubscription = BehaviorSubject();
  final _playerErrorSubscription = StreamController();

  String url;

  final _durationSubject = BehaviorSubject<Duration>();
  Stream<Duration> get duration => _durationSubject.stream;

  final _playerState = BehaviorSubject<PlayerState>();
  Stream get isPlaying => _playerState.stream;

  AudioBloc() {
    _audioPlayer = new AudioPlayer();
    _storage = FirebaseStorage(
        app: _app, storageBucket: 'gs://verboshop-app.appspot.com');

    _audioPlayer.onDurationChanged.listen(_durationSubject.add);

    _audioPlayer.onAudioPositionChanged.listen(_positionSubject.add);

    _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();

      _positionSubject.add(_durationSubject.value);
    });

    _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');

      _playerState.add(PlayerState.stopped);
      _durationSubject.add(new Duration(seconds: 0));
      _positionSubject.add(new Duration(seconds: 0));
    });
  }

  Future play(filename) async {
    final playPosition = (_positionSubject.value != null &&
            _durationSubject.value != null &&
            _positionSubject.value.inMilliseconds > 0 &&
            _positionSubject.value.inMilliseconds <
                _durationSubject.value.inMilliseconds)
        ? _positionSubject.value
        : null;
    final url = await _storage
        .ref()
        .child('ministracoes')
        .child(filename)
        .getDownloadURL();
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) _playerState.add(PlayerState.playing);
  }

  Future pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) _playerState.add(PlayerState.paused);
  }

  Future stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      _playerState.add(PlayerState.stopped);
      _positionSubject.add(new Duration());
    }
  }

  void _onComplete() {
    _playerState.add(PlayerState.stopped);
  }

  @override
  void dispose() {
    stop();

    _durationSubject?.close();
    _positionSubject?.close();
    _playerCompleteSubscription?.close();
    _playerErrorSubscription?.close();
    _playerState?.close();
  }
}
