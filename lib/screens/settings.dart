import 'package:flutter/material.dart';

import '../bluetoothService.dart';

class Settings extends StatefulWidget {

  final BluetoothInterface bt; // tu w tym miejscu widok ma zupełnie wywalone co implementuje komunikację bt,

  Settings(this.bt);

  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {

  ListView _buildListViewOfDevices() {
    List<Container> containers = <Container>[];
    for (var device in widget.bt.devices) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }


  ListView _buildView() {
    return _buildListViewOfDevices();
  }

@override
  void initState() {
    super.initState();
    widget.bt.startScan();
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

