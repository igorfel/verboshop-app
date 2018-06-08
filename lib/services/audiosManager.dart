import 'package:verboshop/models/audio.dart';

class AudiosManager{
  List<Audio> listOfAudios = new List();
  
  AudiosManager(){
    retrieveAudioList();
  }

  /**
   * Access the database to retrieve audio information
   */
  void retrieveAudioList(){
    listOfAudios.add(new Audio(title: "Título 1", minister: "Ministro 1", date: "10/10/2017", url: "http://www.rxlabz.com/labz/audio2.mp3"));
    listOfAudios.add(new Audio(title: "Título 2", minister: "Ministro 3", date: "10/10/2017", url: "http://www.rxlabz.com/labz/audio.mp3"));
    listOfAudios.add(new Audio(title: "Realidades da nova criação", minister: "Pr. Jaelson", date: "25/03/2018", url: "https://vocaroo.com/media_command.php?media=s17dSeJPekw6&command=download_mp3"));

    //return listOfAudios;
  }
}