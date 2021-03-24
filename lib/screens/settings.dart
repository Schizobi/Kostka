import 'package:flutter/material.dart';

import '../bluetoothService.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
    BluetoothService bt = new BluetoothService();
  ListView _buildListViewOfDevices() {
    List<Container> containers = <Container>[];
    for (var device in bt.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
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
    bt.startScan();
  }
@override
  void dispose() {
    super.dispose();
    bt.stopScan();
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

