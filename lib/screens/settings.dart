import 'package:flutter/material.dart';

import '../bluetoothService.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: BluetoothService()
        ),
    );
  }
}
