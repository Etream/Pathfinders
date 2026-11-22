
import 'package:flutter/material.dart';
import 'sensor_service.dart';
import 'heading_slider.dart';

void main() {
  runApp(const MaterialApp(home: SensorTest()));
}

class SensorTest extends StatefulWidget {
  const SensorTest({super.key});

  @override
  State<SensorTest> createState() {
    return _SensorTestState();
  }
}

class _SensorTestState extends State<SensorTest> {

  // Your Member 2 sensor functions.
  final sensor = SensorService();

  // Listen for compass readings.
  late final compass = sensor.getCompassHeading();

  // Starting slider value.
  double heading = 0;

  // Store the GPS message.
  String gpsResult = 'No GPS reading yet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensor Test')),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // TEST 1: Compass
          StreamBuilder<double?>(
            stream: compass,
            builder: (context, snapshot) {

              if (snapshot.hasError) {
                return Text('Compass error: ${snapshot.error}');
              }

              if (snapshot.data == null) {
                return const Text('Compass unavailable');
              }

              return Text(
                'Compass: ${snapshot.data!.round()}°',
              );
            },
          ),

          const SizedBox(height: 30),

          // TEST 2: GPS
          ElevatedButton(
            onPressed: () async {

              // Show loading message.
              setState(() {
                gpsResult = 'Getting GPS location...';
              });

              try {
                // Get the current GPS location.
                final location = await sensor.getCurrentPosition()
                    .timeout(const Duration(seconds: 20));

                if (!mounted) return;

                // Display coordinates on the phone.
                setState(() {
                  gpsResult = 'Latitude: ${location.latitude}\n'
                      'Longitude: ${location.longitude}';
                });

              } catch (error) {

                if (!mounted) return;

                // Display an error if GPS fails.
                setState(() {
                  gpsResult = 'GPS error: $error';
                });
              }
            },
            child: const Text('Test GPS'),
          ),

          const SizedBox(height: 10),

          // Show the GPS result on the emulator.
          Text(
            gpsResult,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // TEST 3: Slider
          Text('Slider direction: ${heading.round()}°'),

          headingSlider(heading, (value) {
            setState(() {
              heading = value;
            });
          }),

        ],
      ),
    );
  }
}

