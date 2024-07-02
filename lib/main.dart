//----------------PARTIE Joystick----------------
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ControlCar',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.233.11/ws'),
    );
    print('WebSocket connected');
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _sendCommand(String command) {
    print('Sending command: $command');
    channel.sink.add(command);
  }

  void _onJoystickChange(StickDragDetails details) {
    // Utiliser les propriétés x et y de StickDragDetails
    double x = details.x;
    double y = details.y;
    int leftSpeed, rightSpeed;

    // Calculer la vitesse des moteurs gauche et droit en fonction de x et y
    leftSpeed = (y * 1000 + x * 500).toInt();
    rightSpeed = (y * 1000 - x * 500).toInt();

    final command = {
      'cmd': 1,
      'data': [leftSpeed, leftSpeed, rightSpeed, rightSpeed]
    };
    _sendCommand(jsonEncode(command));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ControlCar'),
      ),
      body: Center(
        child: Joystick(
          mode: JoystickMode.all,
          listener: _onJoystickChange,
        ),
      ),
    );
  }
}

//----------------------PARTIE BOUTON----------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ControlCar',
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late final WebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();
//     channel = WebSocketChannel.connect(
//       Uri.parse('ws://192.168.233.11/ws'),
//     );
//     print('WebSocket connected');
//   }

//   @override
//   void dispose() {
//     channel.sink.close(status.goingAway);
//     super.dispose();
//   }

//   void _sendCommand(String command) {
//     print('Sending command: $command');
//     channel.sink.add(command);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ControlCar'),
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           // ... Autres widgets
//           Positioned(
//             bottom: 100,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     final reculerCommand = {
//                       'cmd': 1,
//                       'data': [
//                         -1000,
//                         -1000,
//                         -1000,
//                         -1000
//                       ], // Commande pour reculer avec une vitesse diminuée
//                     };
//                     _sendCommand(jsonEncode(reculerCommand));
//                   },
//                   child: const Text('Reculer'),
//                 ),
//                 SizedBox(width: 20), // Espacement entre les boutons
//                 ElevatedButton(
//                   onPressed: () {
//                     final avancerCommand = {
//                       'cmd': 1,
//                       'data': [
//                         1000,
//                         1000,
//                         1000,
//                         1000
//                       ], // Commande pour avancer avec une vitesse
//                     };
//                     _sendCommand(jsonEncode(avancerCommand));
//                   },
//                   child: const Text('Avancer'),
//                 ),
//                 SizedBox(width: 20), // Espacement entre les boutons
//                 ElevatedButton(
//                   onPressed: () {
//                     final gaucheCommand = {
//                       'cmd': 1,
//                       'data': [
//                         -500,
//                         -500,
//                         1000,
//                         1000
//                       ], // Commande pour tourner à gauche
//                     };
//                     _sendCommand(jsonEncode(gaucheCommand));
//                   },
//                   child: const Text('Gauche'),
//                 ),
//                 SizedBox(width: 20), // Espacement entre les boutons
//                 ElevatedButton(
//                   onPressed: () {
//                     final droiteCommand = {
//                       'cmd': 1,
//                       'data': [
//                         1000,
//                         1000,
//                         -500,
//                         -500
//                       ], // Commande pour tourner à droite
//                     };
//                     _sendCommand(jsonEncode(droiteCommand));
//                   },
//                   child: const Text('Droite'),
//                 ),
//                 SizedBox(width: 20), // Espacement entre les boutons
//                 ElevatedButton(
//                   onPressed: () {
//                     final freinCommand = {
//                       'cmd': 1,
//                       'data': [
//                         0,
//                         0,
//                         0,
//                         0
//                       ], // Commande pour arrêter tous les moteurs
//                     };
//                     _sendCommand(jsonEncode(freinCommand));
//                   },
//                   child: const Text('Frein'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
