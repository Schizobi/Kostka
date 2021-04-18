import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kostka/bluetoothService.dart';
import 'package:kostka/events/event_manager.dart';
import 'package:kostka/screens/settings.dart';
import 'package:kostka/screens/today.dart';
import 'package:kostka/screens/week.dart';
import 'package:kostka/view/counter.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int bottomSelectedIndex = 0;
  FToast? fToast;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon: new Icon(Icons.home), label: 'Today'),
      BottomNavigationBarItem(
        icon: new Icon(Icons.settings),
        label: 'Settings',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Week')
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Consumer<EventManager>(
            // ten widget ci wystawia potrzebne zależności i może wywołać przebudowanie jak one się np. zmienią
            builder: (context, em, child) {
          return Today(em);
        }),
        Consumer<EventManager>(
            // ten widget ci wystawia potrzebne zależności i może wywołać przebudowanie jak one się np. zmienią
            builder: (context, em, child) {
          return Week(em);
        }),
        Consumer<BluetoothServiceX>(
            // ten widget ci wystawia potrzebne zależności i może wywołać przebudowanie jak one się np. zmienią
            builder: (context, btService, child) {
          return Settings(btService);
        }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast!.init(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Połączono"),
        ],
      ),
    );


    fToast!.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Consumer<BluetoothServiceX>(
            // ten widget ci wystawia potrzebne zależności i może wywołać przebudowanie jak one się np. zmienią
            builder: (context, btService, child) {
          if (bottomSelectedIndex == 0) {
            return AppBar(title: Text("Home screen"), actions: <Widget>[
              TextButton.icon(

                  onPressed: () async {
                    btService.startScan();
                    _showToast();
                  },
                  icon: btService.isConnected
                      ? Icon(Icons.check, color: Colors.white)
                      : Icon(Icons.play_arrow, color: Colors.white),
                  label: btService.isConnected ? Text('Połączono', style: TextStyle(color: Colors.white)): Text('Szukaj kostki', style: TextStyle(color: Colors.white)),
              )
            ]);
          } else {
            return AppBar(
              title: Text("Home screen"),
            );
          }
        }),
      ),
      body: buildPageView(),
      floatingActionButton: Consumer<EventManager>(
          // ten widget ci wystawia potrzebne zależności i może wywołać przebudowanie jak one się np. zmienią
          builder: (context, em, child) {
        return FloatingActionButton.extended(
          onPressed: () {
            if (em.isPaused) {
              em.start();
            } else {
              em.stop();
            }
          },
          label: em.isPaused
              ? Text("start")
              : Counter(em.getCurrentTask().start, em.currentTaskName),
          icon: Icon(em.isPaused ? Icons.play_arrow : Icons.stop),
          backgroundColor: em.isPaused ? Colors.green : Colors.red,
        );
      }),
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



