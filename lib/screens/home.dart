import 'package:flutter/material.dart';
import 'package:kostka/bluetoothService.dart';
import 'package:kostka/screens/settings.dart';
import 'package:kostka/screens/today.dart';
import 'package:kostka/screens/week.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {


    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          label: 'Today'
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.settings),
        label: 'Settings',
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Week'
      )
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return Consumer<BluetoothServiceX>( // ten widget ci wystawia potrzebne zależności i może wywołać przebudowanie jak one się np. zmienią
      builder: (context, btService, child) {
        return PageView(
          controller: pageController,
          onPageChanged: (index) {
            pageChanged(index);
          },
          children: <Widget>[
            Today(),
            Week(),
            Settings(btService),
          ],
        );
      },

    );
  }

  @override
  void initState() {
    super.initState();
  }



  void pageChanged(int index) {
      setState(
              () {
            bottomSelectedIndex = index;
          }
      );

  }

  void bottomTapped(int index) {
      setState(
              () {
            bottomSelectedIndex = index;
            pageController.animateToPage(
                index, duration: Duration(
                milliseconds: 500
            ), curve: Curves.ease
            );
          }
      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home screen"),
      ),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}
