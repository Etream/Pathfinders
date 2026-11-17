import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class SensorService {

  // Get the phone's Compass direction.
    Stream<double?> getCompassHeading() {

        // Get the compass readings from the library.
        final compass = FlutterCompass.events;

        // If the compass stream is available
        if (compass != null) 
        {
            // Return the direction from each reading.
            return compass.map((event) => event.heading);
        }
        else 
        {
            // If unavailable, return a stream containing null.
            return Stream<double?>.value(null);
        }
    }

  
    Future<Position> getCurrentPosition() async {

        // Check if GPS is turned on.
        bool enabled = await Geolocator.isLocationServiceEnabled();

        if (enabled == false) {
            throw Exception('GPS is turned off');
        }

        // Check if the app has location permission.
        LocationPermission permission = await Geolocator.checkPermission();

        // Ask for permission if it was denied.
        if (permission == LocationPermission.denied)
        {
            permission = await Geolocator.requestPermission();
        }

        // Stop if the app still has no permission.
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) 
        {
            throw Exception('Location permission denied');
        }

        // Get the phone's current location.
        Position location = await Geolocator.getCurrentPosition();

        // Return the location to the rest of the app.
        return location;
    }

}