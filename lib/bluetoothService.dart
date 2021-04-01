import 'package:flutter_blue/flutter_blue.dart';

// w tych dwóch interfejsach powinno być udostępnione wszytsko co jest potrzebne aplikacji dotyczące bt

abstract class BluetoothInterface {
  // interfejs określający łączność bt
  List<BluetoothDeviceInterface> get devices;
  BluetoothDeviceInterface? connectedDevice;
  void startScan();
  void stopScan();
  void connect(var device);
}

abstract class BluetoothDeviceInterface {
  // interfejs definiujący urządzenie bt, trochę na wyrost
  String get name;
  String get id;
}

// a tu ich implementacje, z wykorzystaniem flutter_blue
// w przypadku np. zmiany biblioteki nie trzeba zmieniać w aplikacji nic poza tym nie trzeba będzie zmienić
// a np. dla testów można zrobić klasy które mockują działanie bt
//

class BluetoothService implements BluetoothInterface {
  // implementacja za pomocą biblioteki flutter_blue
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final List<FlutterBlueDevice> _devicesList = <FlutterBlueDevice>[];
  BluetoothDeviceInterface? connectedDevice;
  _addDeviceToList(final BluetoothDevice device) {
    if (!_devicesList.contains(device)) {
      _devicesList.add(FlutterBlueDevice(device));
    }
  }

  void connect(var device) async => await device.connect();

  @override
  void startScan() {
    _flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceToList(device);
      }
    });
    _flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.name.split(' ')[0].toLowerCase() == 'ruuvitag') {
          _addDeviceToList(result.device);
          stopScan();
        }
      }
    });
    _flutterBlue.startScan();
  }

  @override
  void stopScan() {
    _flutterBlue.stopScan();
  }

  @override
  List<BluetoothDeviceInterface> get devices => _devicesList;
}

class FlutterBlueDevice implements BluetoothDeviceInterface {
  final BluetoothDevice _device;

  FlutterBlueDevice(this._device);

  @override
  String get id => _device.id.toString();

  @override
  String get name => _device.name;
}
