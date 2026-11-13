import 'package:flutter/material.dart';
import 'dart:math' as math;

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  // Mock list of campus buildings for the dropdown
  final List<String> buildings = [
    'Minto Centre',
    'Canal Building',
    'Azrieli Pavilion',
    'Herzberg Laboratories',
  ];
  
  String? selectedBuilding = 'Minto Centre';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Navigator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Step 2: Dropdown Menu at the Top
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: selectedBuilding,
                isExpanded: true,
                underline: const SizedBox(),
                items: buildings.map((String building) {
                  return DropdownMenuItem<String>(
                    value: building,
                    child: Text(
                      building,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBuilding = newValue;
                  });
                },
              ),
            ),

            // Step 3: Spinning Arrow in the Middle (using a test angle)
            Transform.rotate(
              angle: 45 * (math.pi / 180), // 45 degrees in radians for testing
              child: const Icon(
                Icons.navigation,
                size: 120,
                color: Colors.blue,
              ),
            ),

            // Step 4: Distance Text at the Bottom
            const Column(
              children: [
                Text(
                  '240 meters away',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Head North-East',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}