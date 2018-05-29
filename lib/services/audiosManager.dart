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
    listOfAudios.add(new Audio(title: "Título 1", minister: "Ministro 1", date: "10/10/2017", url: ":storage/ministração/1"));
    listOfAudios.add(new Audio(title: "Título 2", minister: "Ministro 3", date: "10/10/2017", url: ":storage/ministração/2"));
    listOfAudios.add(new Audio(title: "Título 3", minister: "Ministro 2", date: "10/10/2017", url: ":storage/ministração/3"));

    //return listOfAudios;
  }
}