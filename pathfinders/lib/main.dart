import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pathfinders/campus_data.dart';
import 'ui.dart';
import 'heading_slider.dart';
import 'sensor_service.dart'; 

// //import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class CompassScreen extends StatefulWidget {
//   const CompassScreen({super.key});

//   @override
//   State<CompassScreen> createState() => _CompassScreenState();
// }

// class _CompassScreenState extends State<CompassScreen> {
//   // Mock list of campus buildings for the dropdown
//   final List<String> buildings = [
//     'Minto Centre',
//     'Canal Building',
//     'Azrieli Pavilion',
//     'Herzberg Laboratories',
//   ];
  
//   String? selectedBuilding = 'Minto Centre';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Campus Navigator'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Step 2: Dropdown Menu at the Top
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: DropdownButton<String>(
//                 value: selectedBuilding,
//                 isExpanded: true,
//                 underline: const SizedBox(),
//                 items: buildings.map((String building) {
//                   return DropdownMenuItem<String>(
//                     value: building,
//                     child: Text(
//                       building,
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedBuilding = newValue;
//                   });
//                 },
//               ),
//             ),

//             // Step 3: Spinning Arrow in the Middle (using a test angle)
//             Transform.rotate(
//               angle: 45 * (math.pi / 180), // 45 degrees in radians for testing
//               child: const Icon(
//                 Icons.navigation,
//                 size: 120,
//                 color: Colors.blue,
//               ),
//             ),

//             // Step 4: Distance Text at the Bottom
//             const Column(
//               children: [
//                 Text(
//                   '240 meters away',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Head North-East',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathfinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainNavigatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// TODO: manage the test heading slider and pass it to the ui

class MainNavigatorScreen extends StatefulWidget { // StatefulWidget changes the screen over time; useful for our slider
  const MainNavigatorScreen ({super.key});

  @override
  State<MainNavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<MainNavigatorScreen> {
  final SensorService _sensorService = SensorService();


// TODO: Screen state & Campus coordinates

// Campus coordinates for buildings (Minot, Canal, etc.)
  final List<String> _buildings = campusLocations.keys.toList();
  late String _selectedBuilding = _buildings.first;

  double _testHeading = 0.0;  // _testHeading varibale will represent the direction from 0.0 to 360 degrees

// if GPS hasn't loaded in the emulator, then we can fallback to startign location

  double _currentLat = 45.38206408365617;
  double _currentLng = -75.69977042560764;
  String _gpsStatus = 'Using default campus spot (tap "Update GPS")';

  @override 
  void initState() {
    super.initState();
    _fetchLocation();
  }

// TODO: GPS fetching

  Future<void> _fetchLocation() async {
    setState(() {
      _gpsStatus = 'Fetching the GPS location...';
    });
    
    try {
      final Position location = await _sensorService
        .getCurrentPosition()
        .timeout(const Duration(seconds: 10)); // wait up to 10 seconds for a reading on the GPS, this is for the emulator

      if (!mounted) return;

      setState(() {
        _currentLat = location.latitude;
        _currentLng = location.longitude;
        _gpsStatus = 'GPS updated';
      });

    } catch (e) {
      // if GPS is off, or other reason, keep the fallback coordinates
      if (!mounted) return;
      setState(() {
        _gpsStatus = 'Using simulated campus GPS';
      });
    }
  }

  // TODO: convert the compass into something readable like 'Heading North'
  String _bearingToCardinal(double bearing) {
    // 0 to 360 degrees range
    final normalized = ((bearing % 360) + 360) % 360;

    // Compass sections
    const directions = [
      'North',
      'North-East',
      'East',
      'South-East',
      'South',
      'South-West',
      'West',
      'North-West',
    ];

    final index = ((normalized + 22.5) % 360) ~/ 45;
    return 'Head ${directions[index]}';
  }


// TODO: Visual Layout 

  @override
  Widget build(BuildContext context) {
    // vector will return [distance(in meters), bearing(direction in degrees)]
    final navVector = vector(_currentLat, _currentLng, _selectedBuilding);
    final double distanceMeters = navVector[0];
    final double bearingToTarget = navVector[1];

    // Then to rotate arrow to the direction of bearing that is currently facing
    final double arrowAngle = ((bearingToTarget - _testHeading) % 360 + 360) % 360;

    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Navigator')),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Target: $_selectedBuilding'),
                Text('Distance: ${distanceMeters.round()} m'),
                Text('Arrow angle: ${arrowAngle.round()} degrees'),
                Text(_bearingToCardinal(bearingToTarget)),
                Text(_gpsStatus),
                const SizedBox(height: 16),
                headingSlider(_testHeading, (val) {
                  setState(() => _testHeading = val);
                }),
              ],
          ),
        ),
    );
  }
}
//             // Step 2: Dropdown Menu at the Top
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: DropdownButton<String>(
//                 value: selectedBuilding,
//                 isExpanded: true,
//                 underline: const SizedBox(),
//                 items: buildings.map((String building) {
//                   return DropdownMenuItem<String>(
//                     value: building,
//                     child: Text(
//                       building,
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedBuilding = newValue;
//                   });
//                 },
//               ),
//             ),

//             // Step 3: Spinning Arrow in the Middle (using a test angle)
//             Transform.rotate(
//               angle: 45 * (math.pi / 180), // 45 degrees in radians for testing
//               child: const Icon(
//                 Icons.navigation,
//                 size: 120,
//                 color: Colors.blue,
//               ),
//             ),

//             // Step 4: Distance Text at the Bottom
//             const Column(
//               children: [
//                 Text(
//                   '240 meters away',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Head North-East',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }