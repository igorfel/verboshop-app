import "package:flutter/material.dart";
import 'package:audioplayers_with_rate/audioplayers.dart';
import 'package:verboshop/components/Lists/audioList.dart';
import 'package:verboshop/pages/Account/account.dart';
import 'package:verboshop/pages/Search/searchPage.dart';

final AudioPlayer audioPlayer = new AudioPlayer();

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showPlayIcon = true;

  int _selectedIndex = 1;
  final _widgetOptions = [AudioList(audioPlayer), SearchPage(), AccountPage()];

  @override
  void dispose() {
    super.dispose();

    audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('VERBO STORE'),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Início')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Procurar')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text('Conta')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.red[900],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
