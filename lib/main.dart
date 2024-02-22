import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

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

class CircleMarkersDemo extends StatelessWidget {
  final double circleRadius = 100; // radius of the circle
  final int numOfMarkers = 36; // number of markers (every 10 degrees)
  final double targetLat = 40.9254; // Your latitude
  final double targetLong = 73.9629; // Your longitude
  final double myLat = 40.5008; // Target latitude
  final double myLong = 74.4474; // Target longitude
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass App Testing'),
      ),
      body: Center(
        child: CustomPaint(
          size: const Size(300, 300), // adjust size as needed
          painter: CircleMarkersPainter(
            circleRadius: circleRadius,
            numOfMarkers: numOfMarkers,
            targetLat: targetLat,
            targetLong: targetLong,
            myLat: myLat,
            myLong: myLong,
          ),
        ),
      ),
    );
  }
}

class CircleMarkersPainter extends CustomPainter {
  final double circleRadius;
  final int numOfMarkers;
  final double targetLat;
  final double targetLong;
  final double myLat;
  final double myLong;

  CircleMarkersPainter({
    required this.circleRadius, 
    required this.numOfMarkers, 
    required this.targetLat,
    required this.targetLong,
    required this.myLat,
    required this.myLong,
    });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw circle
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, circleRadius, paint);

    // Calculate relative angle
    final myX = targetLong;
    final myY = targetLat;
    final targetX = myLong;
    final targetY = myLat;
    final dx = targetX - myX;
    final dy = targetY - myY;
    final angle = math.atan2(dy, dx);

    // Draw markers
    final markerPaint = Paint()..color = Colors.red;
    final markerX = center.dx + circleRadius * math.cos(angle);
    final markerY = center.dy + circleRadius * math.sin(angle);
    canvas.drawCircle(Offset(markerX, markerY), 4, markerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}