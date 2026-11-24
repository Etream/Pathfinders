import 'dart:async';
import 'dart:math' as math; // dart math for rotating arrow
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pathfinders/campus_data.dart';
import 'sensor_service.dart'; 


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
  StreamSubscription<CompassEvent>? _compassSub; // Stream subscriptions and timer for the live compass and GPS (10s)
  StreamSubscription<Position>? _positionSub;
  Timer? _gpsTimer;

  // To prevent theGPS fetch and the slider from being overwritten by compass
  bool _isFetchingLocation = false; 
  bool _useManualHeading = false;

// TODO: Screen state & Campus coordinates

// Campus coordinates for buildings (Minot, Canal, etc.)
  final List<String> _buildings = campusLocations.keys.toList();
  late String _selectedBuilding = _buildings.first;

  double _testHeading = 0.0;  // _testHeading varibale will represent the direction from 0.0 to 360 degrees

// if GPS hasn't loaded in the emulator, then we can fallback to starting location

  double _currentLat = 45.38206408365617;
  double _currentLng = -75.69977042560764;
  String _gpsStatus = 'Using default campus spot (tap "Update GPS")';

  @override 
  void initState() {
    super.initState();
    _fetchLocation();

    // Listen to compass headings unless the user has locked in a heading with the slider
    _compassSub = FlutterCompass.events?.listen((CompassEvent event) {
      final double? heading = event.heading;
      if (heading != null && mounted && !_useManualHeading) {
        final double normalizedHeading = ((heading % 360) + 360) % 360;
        setState(() {
          _testHeading = normalizedHeading;
        });
      }
    });
  
    // Listen for continous position updates whenever the user has moved about 2 meters
  _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen(
      (Position position) {
        if (!mounted) return;
        setState(() {
          _currentLat = position.latitude;
          _currentLng = position.longitude;
          _gpsStatus = 'Live GPS tracking';
        });
      },
      onError: (_) {
        if (!mounted) return;
        setState(() {
          _gpsStatus = 'Using simulated/fallback GPS';
        });
      },
    );

    // GPS refresh every 10 seconds
    _gpsTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) {
        _fetchLocation();
      }
    });
  }

  @override
  void dispose() {
    // Cancel whatever active timer and stream subsscriptions to prevent memory leaks
    _gpsTimer?.cancel();
    _compassSub?.cancel();
    _positionSub?.cancel();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    // Skip fetching if GPS request is already being done or the widget isn't mounted anymore
    if (_isFetchingLocation || !mounted) return;
    _isFetchingLocation = true;

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
      debugPrint('failed: $e');
      // if GPS is off, or other reason, keep the fallback coordinates
      if (!mounted) return;
      setState(() {
        _gpsStatus = 'Using simulated campus GPS';
      });
    } finally {
      // Release the fetch lcok so the timer or button calls can run
      _isFetchingLocation = false;
    }
  }
  

  // TODO: convert the compass into something readable like 'Heading North'
  String _bearingToCardinal(double bearing) {
    // Normalize any angles, like negative ones, into a 0-360 degree range
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


  @override
  Widget build(BuildContext context) {
    // vector will return [distance(in meters), bearing(direction in degrees)]
    final navVector = vector(_currentLat, _currentLng, _selectedBuilding);
    final double distanceMeters = (navVector[0] as num).toDouble();

    // Normalize bearing so negative bearings, i.e -135 degress -> 225 degress
    final double bearingToTarget = ((navVector[1] as num).toDouble() % 360 + 360) % 360;

    // Rotate the arrow relative to user's current heading
    final double arrowAngle = ((bearingToTarget - _testHeading) % 360 + 360) % 360;

    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder Navigator'),
        actions: [
          IconButton(
            onPressed: _fetchLocation,
            icon: const Icon(Icons.my_location),
            tooltip: 'Update GPS',
          ),
        ],
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
                value: _selectedBuilding,
                isExpanded: true,
                underline: const SizedBox(),
                items: _buildings.map((String building) {
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
                    _selectedBuilding = newValue!;
                  });
                },
              ),
            ),

            // Step 3: Spinning Arrow in the Middle (using a test angle)
            Transform.rotate(
              angle: arrowAngle * (math.pi / 180), // 45 degrees in radians for testing
              child: const Icon(
                Icons.navigation,
                size: 120,
                color: Colors.blue,
              ),
            ),
            
            // Manual heading slider
            Column(
              children: [
                Text('Heading: ${_testHeading.round()}°'),
                //Slider(
                  // min: 0,
                  // max: 360,
                  // value: _testHeading.clamp(0.0, 360.0),
                  // onChanged: (double newValue) {
                  //   setState(() {
                  //     _useManualHeading = true;
                  //     _testHeading = ((newValue % 360) + 360) % 360;
                  //   });
                //   },
                // ),
              ],
            ),
            // Step 4: Distance Text at the Bottom
            Column(
              children: [
                Text(
                  _bearingToCardinal(bearingToTarget),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${distanceMeters.round()} meters away',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bearing: ${bearingToTarget.round()}°',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _gpsStatus,
                  style: const TextStyle(
                    fontSize: 12,
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
