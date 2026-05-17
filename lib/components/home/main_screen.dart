import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  final GlobalKey mapKey;
  final Function setController;
  final Set<Polyline> polylines;
  late final GoogleMapController? mapController;
  MapScreen({super.key, required this.polylines, this.mapController, required this.setController, required this.mapKey});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  // Coordinate di esempio per Napoli e Roma
  final String origin = 'Napoli'; // Napoli
  final String destination = 'Roma'; // Roma


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: widget.mapKey,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(41.9028, 12.4964),
            zoom: 5,
          ),
          onMapCreated: (controller) {
            widget.setController(controller);
          },
          polylines: widget.polylines,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
            ),
          },
        ),
      ),
    );
  }
}

class PointLatLng {
  final double latitude;
  final double longitude;

  PointLatLng(this.latitude, this.longitude);
}