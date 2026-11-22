
import 'package:flutter/material.dart';

// Create a slider for the phone's direction.
Widget headingSlider(double heading, void Function(double) changeHeading) {

  return Slider(
    value: heading,             // Current direction
    min: 0,                     // Minimum is 0 degrees
    max: 360,                   // Maximum is 360 degrees
    divisions: 360,             // Move 1 degree at a time
    onChanged: changeHeading,   // Update when slider moves
  );
}
