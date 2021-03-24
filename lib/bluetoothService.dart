import 'package:flutter_blue/flutter_blue.dart';


class BluetoothService{
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];

  _showDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
        devicesList.add(device);
    }
  }
  void startScan() {
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _showDeviceTolist(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _showDeviceTolist(result.device);
      }
    });
    flutterBlue.startScan();
  }
  void stopScan() {
    flutterBlue.stopScan();
  }

}

