import 'package:flutter/material.dart';
import 'package:kostka/bluetoothService.dart';
import 'package:kostka/db/event_db.dart';
import 'package:kostka/db/shared_preferences_db.dart';
import 'package:kostka/events/event_manager.dart';
import 'package:kostka/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  EventDB db = SharedPreferencesDB(prefs);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,

      home: MultiProvider(
          providers: [
            ChangeNotifierProvider<BluetoothServiceX>(create: (_) => BluetoothServiceX()),
            ChangeNotifierProxyProvider<BluetoothServiceX,EventManager>(create:  (_) => EventManager(db), update: (_, bt, e)  {
              if(bt.isConnected) {
                print("SET STREAM");
                e!.setEdgeStream(bt.edgeStream);
              }
              return e!;
              },)// tutaj raz stworzy się ten serwis i będzie dostępny gdziekolwiek niżej w drzewie poprzez widget consumer
          ],
          child: Home()))
  );
}


