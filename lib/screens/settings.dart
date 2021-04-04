import 'package:flutter/material.dart';

import '../bluetoothService.dart';

class Settings extends StatefulWidget {
  final BluetoothInterface bt; // tu w tym miejscu widok ma zupełnie wywalone co implementuje komunikację bt,

  Settings(this.bt);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  IconData icon = Icons.cancel_presentation;

  Widget buildSearchView() {
    return Container(
      child: ElevatedButton(
        child: Text(
          'Szukaj Kostki',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          widget.bt.startScan();
        },
      ),
    );
  }

  Widget buildInfoView(){
   return Column(
     children: [
       Text('found device: ${widget.bt.hasDevice}'),
       Text('is scanning: ${widget.bt.isScanning}'),
       Text('is connected: ${widget.bt.isConnected}'),

       if(widget.bt.connectedDevice!=null)Text('name: ${widget.bt.connectedDevice!.name}'),
       if(widget.bt.connectedDevice!=null)Text('id: ${widget.bt.connectedDevice!.id}'),
       Container(height: 40),
       if(widget.bt.connectedDevice!=null)Text('Strona kostki: ${widget.bt.edge}'),
     ],
   );
  }

  Widget _buildView() {
    return Column(
      children: [
        buildInfoView(),
        if(!widget.bt.hasDevice)buildSearchView()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.bt.stopScan();
    super.dispose();
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
