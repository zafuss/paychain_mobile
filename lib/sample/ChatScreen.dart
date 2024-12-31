
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({Key? key}) : super(key: key);

  @override
  State<Chatscreen> createState() => _Chatscreen();
}

class _Chatscreen extends State<Chatscreen> {



  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final connection = HubConnectionBuilder()
        .withUrl(
        'https://funtealkayak80.conveyor.cloud/chatHub',
        HttpConnectionOptions(
          /*client: IOClient(
              HttpClient()..badCertificateCallback = (x, y, z) => true),
          logging: (level, message) => print(message),*/
        ))
        .build();
    await connection.start();
    print("after start");
    connection.on('ReceiveMessage', (message) {
      print(message.toString());
    });

    await connection.invoke('SendMessage', args: ['Bob', 'Says hi!']);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SignalR Plugin Example App"),
        ),
        body: Center(
          child: Text("data"),
        ),

      ),
    );
  }


}