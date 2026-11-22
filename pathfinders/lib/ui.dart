import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'campus_data.dart';

class CompassScreen extends StatefulWidget {
  final double? userLatitude;
  final double? userLongitude;
  final double? compassHeading;

  const CompassScreen({
    super.key,
    this.userLatitude,
    this.userLongitude,
    this.compassHeading,
  });

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {

  // Mock list of campus buildings for the dropdown
  final List<String> buildings = campusLocations.keys.toList();
  
  String? selectedBuilding = 'MacOdrum Library';

  @override
  void initState() {
    super.initState();
    selectedBuilding = buildings.isNotEmpty ? buildings.first : null;
  }

  @override
  Widget build(BuildContext context) {

    //Fallback values while testing before live GPS/compass are passed in
    final double lat = widget.userLatitude ?? 45.3827;
    final double lng = widget.userLongitude ?? -75.6982;
    final double heading = widget.compassHeading ?? 0.0;

    double distanceMeters = 240.0;
    double bearingDegrees = 45.0;

    if (selectedBuilding != null) {
      final metrics = vector(lat, lng, selectedBuilding!);
      distanceMeters = metrics[0];
      bearingDegrees = metrics[1];
    }

    final double arrowAngleRadians = (bearingDegrees - heading) * (math.pi / 180);

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
              angle: arrowAngleRadians, // 45 degrees in radians for testing
              child: const Icon(
                Icons.navigation,
                size: 120,
                color: Colors.blue,
              ),
            ),

            // Step 4: Distance Text at the Bottom
            Column(
              children: [
                Text(
                  '${distanceMeters.round()} meters away',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Bearing: ${bearingDegrees.round()}',
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