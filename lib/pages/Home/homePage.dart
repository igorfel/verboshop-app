import "package:flutter/material.dart";
import 'package:verboshop/blocs/audioBloc.dart';
import 'package:verboshop/blocs/blocProvider.dart';
import 'package:verboshop/components/Lists/audioList.dart';
import 'package:verboshop/pages/Account/account.dart';
import 'package:verboshop/pages/Search/searchPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  AudioBloc _audioBloc;
  bool showPlayIcon = true;

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();

    _audioBloc = new AudioBloc();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('VERBO STORE'),
        centerTitle: true,
      ),
      body: Center(
        child: BlocProvider(
            bloc: _audioBloc,
            child: [AudioList(), SearchPage(), AccountPage()]
                .elementAt(_selectedIndex)),
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
