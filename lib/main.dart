import 'package:flutter/material.dart';
import 'package:kostka/bluetoothService.dart';
import 'package:kostka/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
          providers: [
            Provider<BluetoothService>(create: (_) => BluetoothService()) // tutaj raz stworzy się ten serwis i będzie dostępny gdziekolwiek niżej w drzewie poprzez widget consumer
          ],
          child: Home()))
  );
}


