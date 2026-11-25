# Pathfinder Navigator

A lightweight, glanceable Flutter mobile application built for the **Dev 2.0 Hackathon** to help students navigate the **Carleton University** campus using live GPS coordinates, compass orientation, and real-time bearing vectors.

---

## Overview

Instead of requiring users to pinch, zoom, and interpret dense street maps while walking across campus, **Pathfinder** provides an immediate, heads-up directional interface:

* **Destination Picker:** Select from 44 Carleton University buildings and campus landmarks.
* **Live Directional Arrow:** Rotates dynamically relative to your current compass heading so you always know which way to turn.
* **Distance & Cardinal Guidance:** Displays straight-line distance in meters, normalized target bearing (`0°–360°`), and plain-English directions (e.g., *Head South-West*).
* **Resilient Location Tracking:** Combines continuous GPS position streaming, guarded 10-second periodic location refreshes, and default campus fallback coordinates for reliable indoor or emulator testing.

---

## Tech Stack

* **Framework:** Flutter (Dart)
* **Location Services:** [`geolocator`](https://pub.dev/packages/geolocator)
* **Compass & Orientation:** [`flutter_compass`](https://pub.dev/packages/flutter_compass)
* **Math & Asynchronous State:** `dart:math`, `dart:async`

---

## Project Architecture

The codebase is organized into decoupled layers so data, hardware sensors, and UI state remain clean and independently testable:

```text
lib/
├── main.dart            # App entry point, state management, stream lifecycle & reactive UI
├── campus_data.dart     # Carleton University building coordinates (44 locations) & vector math
├── sensor_service.dart  # Device location permission & GPS retrieval wrapper
├── heading_slider.dart  # Manual heading test controls
└── ui.dart              # Reusable UI components
