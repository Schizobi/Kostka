import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// w tych dwóch interfejsach powinno być udostępnione wszytsko co jest potrzebne aplikacji dotyczące bt

abstract class BluetoothInterface {
  // interfejs określający łączność bt
  bool get hasDevice;
  bool get isConnected;
  bool get isConnecting;
  bool get isScanning;
  String get name;
  BluetoothDeviceInterface? connectedDevice;
  void startScan();
  void stopScan();

  int get edge;
}

abstract class BluetoothDeviceInterface {
  // interfejs definiujący urządzenie bt, trochę na wyrost
  String get name;
  String get id;

  Future<void> connect();
}

// a tu ich implementacje, z wykorzystaniem flutter_blue
// w przypadku np. zmiany biblioteki nie trzeba zmieniać w aplikacji nic poza tym nie trzeba będzie zmienić
// a np. dla testów można zrobić klasy które mockują działanie bt
//

class BluetoothServiceX extends ChangeNotifier implements BluetoothInterface  {
  // implementacja za pomocą biblioteki flutter_blue
  bool isScanning = false;
  bool isConnected = false;
  bool hasDevice = false;
  bool isConnecting = false;
  int edge=0;

  final StreamController<int> edgeStreamController = StreamController<int>();
  Stream<int> get edgeStream => edgeStreamController.stream.asBroadcastStream();


  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDeviceInterface? connectedDevice;


  BluetoothServiceX(){
    startScan();
  }
  String get name => ruuviDevice != null ? ruuviDevice!.name:"";
  FlutterBlueDevice? ruuviDevice;

  StreamSubscription? btMessagesSubscription;

  Future<void> _connect(FlutterBlueDevice device)async{

    await device.connect();
    device.device.state.listen((state) {
      switch(state) {
        case BluetoothDeviceState.disconnected:
          isConnected = false;
          ruuviDevice = null;
          notifyListeners();
          break;
        case BluetoothDeviceState.connecting:
          isConnecting = true;
          break;
        case BluetoothDeviceState.connected:
          isConnected = true;
          isConnecting = false;
          notifyListeners();
          break;
        case BluetoothDeviceState.disconnecting:
        //??
          break;
      }
    });


    List<BluetoothService> services = await device.device.discoverServices();
    services.forEach((service) {
      if(service.uuid.toString()=="3e440001-f5bb-357d-719d-179272e4d4d9"){
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {
          if(c.uuid.toString()=="3e440002-f5bb-357d-719d-179272e4d4d9"){
            c.setNotifyValue(true);
            btMessagesSubscription?.cancel();
            btMessagesSubscription = c.value.listen((value) {
              if(value.isNotEmpty) {
                edge = value[0];
                print("BT RECEIVED ${value[0]}");
                edgeStreamController.add(edge);
              }
              // do something with new value
            });
          }

        }
      }
    });

  }

  // List<BluetoothService> services = await device.discoverServices();
  // services.forEach((service) {
  // // do something with service
  // });

  @override
  void startScan() {
    isScanning=true;
    _flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.name.split(' ')[0].toLowerCase() == 'ruuvitag') {
          hasDevice=true;
          notifyListeners();
          ruuviDevice = FlutterBlueDevice(result.device);
          _connect(ruuviDevice!);
          stopScan();
        }
      }
    });
    _flutterBlue.startScan();
  }

  @override
  void stopScan() {
    _flutterBlue.stopScan();
    btMessagesSubscription?.cancel();
    isScanning=false;
    notifyListeners();
  }

  @override
  void dispose() {
    stopScan();
    edgeStreamController.close();
    super.dispose();
  }



}

class FlutterBlueDevice implements BluetoothDeviceInterface {
  final BluetoothDevice device;

  FlutterBlueDevice(this.device);

  @override
  String get id => device.id.toString();

  @override
  String get name => device.name;

  @override
  Future<void> connect() {
    return device.connect();
  }



}
