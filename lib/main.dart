import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ControlCar',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(camera: camera),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;

  const HomeScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      ManualControlScreen(camera: widget.camera),
      const AutonomousControlScreen(),
      const SensorInfoScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text('Contrôler la voiture'),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            label: 'Manuel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_mode),
            label: 'Autonome',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Capteurs',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ManualControlScreen extends StatefulWidget {
  final CameraDescription camera;

  const ManualControlScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _ManualControlScreenState createState() => _ManualControlScreenState();
}

class _ManualControlScreenState extends State<ManualControlScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: 50,
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: 300,
                  height: 200,
                  child: CameraPreview(_controller),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Positioned(
          top: 300,
          child: ElevatedButton(
            onPressed: () {
              // Logique de commande manuelle pour avancer
            },
            child: const Text('Avancer'),
          ),
        ),
        Positioned(
          left: 100,
          top: 400,
          child: ElevatedButton(
            onPressed: () {
              // Logique de commande manuelle pour tourner à gauche
            },
            child: const Text('Gauche'),
          ),
        ),
        Positioned(
          right: 100,
          top: 400,
          child: ElevatedButton(
            onPressed: () {
              // Logique de commande manuelle pour tourner à droite
            },
            child: const Text('Droite'),
          ),
        ),
        Positioned(
          bottom: 100,
          child: ElevatedButton(
            onPressed: () {
              // Logique de commande manuelle pour reculer
            },
            child: const Text('Reculer'),
          ),
        ),
      ],
    );
  }
}

class AutonomousControlScreen extends StatelessWidget {
  const AutonomousControlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Mode de conduite autonome',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Logique de démarrage du mode autonome
          },
          child: const Text('Démarrer le trajet prédéfini'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Logique d'arrêt du mode autonome
          },
          child: const Text('Arrêter'),
        ),
      ],
    );
  }
}

class SensorInfoScreen extends StatelessWidget {
  const SensorInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Informations des capteurs',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        // Ajoutez ici les affichages des données des capteurs
        Text(
          'Capteur 1: ""',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Capteur 2: ""',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        // Ajoutez d'autres capteurs si nécessaire
      ],
    );
  }
}



//----------------
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'ControlCar',
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   static const List<Widget> _widgetOptions = <Widget>[
//     ManualControlScreen(),
//     AutonomousControlScreen(),
//     SensorInfoScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Center(
//           child: Text('Contrôler la voiture'),
//         ),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.drive_eta),
//             label: 'Manuel',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.auto_mode),
//             label: 'Autonome',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.sensors),
//             label: 'Capteurs',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class ManualControlScreen extends StatelessWidget {
//   const ManualControlScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         Positioned(
//           top: 300,
//           child: ElevatedButton(
//             onPressed: () {
//               // Logique de commande manuelle pour avancer
//             },
//             child: const Text('Avancer'),
//           ),
//         ),
//         Positioned(
//           left: 100,
//           child: ElevatedButton(
//             onPressed: () {
//               // Logique de commande manuelle pour tourner à gauche
//             },
//             child: const Text('Gauche'),
//           ),
//         ),
//         Positioned(
//           right: 100,
//           child: ElevatedButton(
//             onPressed: () {
//               // Logique de commande manuelle pour tourner à droite
//             },
//             child: const Text('Droite'),
//           ),
//         ),
//         Positioned(
//           bottom: 300,
//           child: ElevatedButton(
//             onPressed: () {
//               // Logique de commande manuelle pour reculer
//             },
//             child: const Text('Reculer'),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class AutonomousControlScreen extends StatelessWidget {
//   const AutonomousControlScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         const Text(
//           'Mode de conduite autonome',
//           style: TextStyle(fontSize: 24),
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
//             // Logique de démarrage du mode autonome
//           },
//           child: const Text('Démarrer le trajet prédéfini'),
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () {
//             // Logique d'arrêt du mode autonome
//           },
//           child: const Text('Arrêter'),
//         ),
//       ],
//     );
//   }
// }

// class SensorInfoScreen extends StatelessWidget {
//   const SensorInfoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           'Informations des capteurs',
//           style: TextStyle(fontSize: 24),
//         ),
//         SizedBox(height: 20),
//         // Ajoutez ici les affichages des données des capteurs
//         Text(
//           'Capteur 1: ""',
//           style: TextStyle(fontSize: 18),
//         ),
//         SizedBox(height: 10),
//         Text(
//           'Capteur 2: ""',
//           style: TextStyle(fontSize: 18),
//         ),
//         SizedBox(height: 10),
//         // Ajoutez d'autres capteurs si nécessaire
//       ],
//     );
//   }
// }
//----------------------------------

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'ControlCar',
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   static const List<Widget> _widgetOptions = <Widget>[
//     ManualControlScreen(),
//     AutonomousControlScreen(),
//     SensorInfoScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Center(
//           child: Text('Contrôler la voiture'),
//         ),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.drive_eta),
//             label: 'Manuel',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.auto_mode),
//             label: 'Autonome',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.sensors),
//             label: 'Capteurs',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class ManualControlScreen extends StatelessWidget {
//   const ManualControlScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         Positioned(
//           top: 50,
//           child: Container(
//             width: 300,
//             height: 200,
//             color: Colors.black, // Placeholder for camera feed
//             child: const Center(
//               child: Text(
//                 'Caméra',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 300,
//           child: ElevatedButton(
//             onPressed: () {
//               // Logique de commande manuelle pour avancer
//             },
//             child: const Text('Avancer'),
//           ),
//         ),
//         Positioned(
//           left: 100,
//           top: 400,
//           child: ElevatedButton(
//             onPressed: () {
//               // Logique de commande manuelle pour tourner à gauche
//             },
//             child: const Text('Gauche'),
//           ),
//         ),
//         Positioned(
//           right: 100,
//           top: 400,
//           child: ElevatedButton(
//             onPressed: () {
//               // Logique de commande manuelle pour tourner à droite
//             },
//             child: const Text('Droite'),
//           ),
//         ),
//         Positioned(
//           bottom: 100,
//           child: ElevatedButton(
//             onPressed: () {
//               // Logique de commande manuelle pour reculer
//             },
//             child: const Text('Reculer'),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class AutonomousControlScreen extends StatelessWidget {
//   const AutonomousControlScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         const Text(
//           'Mode de conduite autonome',
//           style: TextStyle(fontSize: 24),
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
//             // Logique de démarrage du mode autonome
//           },
//           child: const Text('Démarrer le trajet prédéfini'),
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () {
//             // Logique d'arrêt du mode autonome
//           },
//           child: const Text('Arrêter'),
//         ),
//       ],
//     );
//   }
// }

// class SensorInfoScreen extends StatelessWidget {
//   const SensorInfoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           'Informations des capteurs',
//           style: TextStyle(fontSize: 24),
//         ),
//         SizedBox(height: 20),
//         // Ajoutez ici les affichages des données des capteurs
//         Text(
//           'Capteur 1: ""',
//           style: TextStyle(fontSize: 18),
//         ),
//         SizedBox(height: 10),
//         Text(
//           'Capteur 2: ""',
//           style: TextStyle(fontSize: 18),
//         ),
//         SizedBox(height: 10),
//         // Ajoutez d'autres capteurs si nécessaire
//       ],
//     );
//   }
// }

