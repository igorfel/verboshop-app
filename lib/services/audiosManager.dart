import 'package:verboshop/models/audio.dart';
import 'package:audioplayers/audioplayer.dart';
import 'dart:async';

class AudiosManager {
  List<Audio> listOfAudios = new List();

  bool isPlaying = false;
  int currentPlaying = -1, lastPlayingIndex = -1;
  Duration lastDuration, lastPosition;
  String currentTitle, currentContent;

  AudioPlayer audioPlayer = new AudioPlayer();
  
  AudiosManager() {
    retrieveAudioList();
  }
  
  /**
   * Access the database to retrieve audio information
   */
  void retrieveAudioList() {
    listOfAudios.add(new Audio(title: "Título 1", minister: "Ministro 1", date: "10/10/2017", url: "http://www.rxlabz.com/labz/audio2.mp3"));
    listOfAudios.add(new Audio(title: "Título 2", minister: "Ministro 3", date: "10/10/2017", url: "http://www.rxlabz.com/labz/audio.mp3"));
    listOfAudios.add(new Audio(title: "Realidades da nova criação", minister: "Pr. Jaelson", date: "25/03/2018", url: "https://vocaroo.com/media_command.php?media=s17dSeJPekw6&command=download_mp3"));
    listOfAudios.add(new Audio(title: "Escatologia - Parte 1", minister: "Pr. Antonio Teste", date: "25/03/2018", url: "http://www.rxlabz.com/labz/audio.mp3"));
    listOfAudios.add(new Audio(title: "Família um projeto de Deus", minister: "Adriane Oliveira Teste", date: "25/03/2018", url: "http://www.rxlabz.com/labz/audio.mp3"));

    //await new Future.delayed(new Duration(seconds: 3));

    //return null;
  }

  Future play(int index) async {
    if(isPlaying && currentPlaying == index) return;
    
    if(isPlaying || index != lastPlayingIndex)
      audioPlayer.stop();

    final result = await audioPlayer.play(listOfAudios[index].url, isLocal: false);

    if(result == 1) {
      isPlaying = true;
      currentPlaying = index;

      print("Played: " + listOfAudios[currentPlaying].title);
    }
  }

  Future pause() async {
    if(!isPlaying) return;

    final result = await audioPlayer.pause();

    if(result == 1) {
      isPlaying = false;
      lastPlayingIndex = currentPlaying;
      currentPlaying = -1;

      print("Paused: " + listOfAudios[lastPlayingIndex].title);
    }
  }
  
  Future resume() async {
    await play(lastPlayingIndex);
  }

  void stop() {
    audioPlayer.stop();
    isPlaying = false;
    currentPlaying = -1;
  }

  void complete() {
    isPlaying = false;
    lastPlayingIndex = currentPlaying;
    currentPlaying = -1;

    print("Completed: " + listOfAudios[lastPlayingIndex].title);
  }
}