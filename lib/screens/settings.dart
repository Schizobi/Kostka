import 'package:flutter/material.dart';

import '../bluetoothService.dart';

class Settings extends StatefulWidget {
  final BluetoothInterface
      bt; // tu w tym miejscu widok ma zupełnie wywalone co implementuje komunikację bt,

  Settings(this.bt);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  IconData icon = Icons.cancel_presentation;


  Widget connect() {
    return       Container(
      height: 90,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text(widget.bt.devices[0].name),
                Text(widget.bt.devices[0].id.toString()),
              ],
            ),
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 160.0),
                child: FlatButton(
                  color: Colors.blue,
                  child: Text(
                    'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {

                    for (var device in widget.bt.devices) {
                      widget.bt.stopScan();
                      try {
                        widget.bt.connect(device);
                      } catch (e) {
                        if (e != 'already_connected') {
                          throw e;
                        }
                      }
                      setState(() {
                        widget.bt.connectedDevice = device;
                        icon = Icons.check;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Icon(icon),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget search() {
    return Container(
      child: FlatButton(
        color: Colors.blue,
        child: Text(
          'Szukaj Kostki',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          widget.bt.startScan();
          connect();
        },
      ),
    );
  }

  Widget _buildView() {
    if (widget.bt.devices.length != 0) {
      return  connect();
    } else {
      return search();
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.bt.devices.length);
  }

  @override
  void dispose() {
    super.dispose();
    widget.bt.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildView(),
      ),
    );
  }
}
