import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_compass/flutter_compass.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compass App Testing',
      home: CircleMarkersDemo(),
    );
  }
}

class CircleMarkersDemo extends StatefulWidget {
  @override
  _CircleMarkersDemoState createState() => _CircleMarkersDemoState();
}

class _CircleMarkersDemoState extends State<CircleMarkersDemo> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass App'),
      ),
      body: _selectedIndex == 0 ? MarkerView() : BlankPageView(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Compass View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.square_foot),
            label: 'Contacts View',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Compass View
class MarkerView extends StatefulWidget {
  @override
  _MarkerViewState createState() => _MarkerViewState();
}

class _MarkerViewState extends State<MarkerView> {
  final double circleRadius = 100; // radius of the circle
  final int numOfMarkers = 36; // number of markers (every 10 degrees)
  final double myLatitude = 40.5008; // Your latitude
  final double myLongitude = 74.4474; // Your longitude
  StreamSubscription<CompassEvent>? _compassSubscription; // Nullable StreamSubscription
  late double _heading = 0;
  List<TargetMarker> targetMarkers = [
    TargetMarker(LatLng(48.8566, 2.3522), Colors.red), // Paris
    TargetMarker(LatLng(36.7783, 119.4179), Colors.green), // Cali
    TargetMarker(LatLng(82.8628, 135.0000), Colors.blue), // Antarc
  ];

  @override
  void initState() {
    super.initState();
    // Initialize compass and start listening for updates if _compassSubscription is not null
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _heading = event.heading ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel(); // Cancel subscription if not null
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900], // Set the background color here
      alignment: Alignment.center, // Center the child
      child: CustomPaint(
        size: const Size(300, 300), // adjust size as needed
        painter: CircleMarkersPainter(
          circleRadius: circleRadius,
          numOfMarkers: numOfMarkers,
          myLat: myLatitude,
          myLong: myLongitude,
          heading: _heading,
          targetMarkers: targetMarkers,
        ),
      ),
    );
  }
}

class BlankPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Blank Page View'),
    );
  }
}

class CircleMarkersPainter extends CustomPainter {
  final double circleRadius;
  final int numOfMarkers;
  final double myLat;
  final double myLong;
  final double heading;
  final List<TargetMarker> targetMarkers;

  CircleMarkersPainter({
    required this.circleRadius,
    required this.numOfMarkers,
    required this.myLat,
    required this.myLong,
    required this.heading,
    required this.targetMarkers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw circle
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, circleRadius, paint);

    // Draw markers for each target coordinate
    for (final marker in targetMarkers) {
      final targetCoord = marker.coordinate;
      final color = marker.color;
      final dx = targetCoord.longitude - myLong;
      final dy = targetCoord.latitude - myLat;
      final angle = math.atan2(dy, dx);
      final markerPaint = Paint()..color = color;
      final markerX = center.dx + circleRadius * math.cos(angle);
      final markerY = center.dy + circleRadius * math.sin(angle);
      canvas.drawCircle(Offset(markerX, markerY), 7, markerPaint); // # is size of the markers
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}

class TargetMarker {
  LatLng coordinate;
  final Color color;

  TargetMarker(this.coordinate, this.color);
}