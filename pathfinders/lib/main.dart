import 'package:flutter/material.dart';
import 'ui.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        primarySwatch: Colors.blue,
      ),
      home: CompassScreen(),
    );
  }
}
