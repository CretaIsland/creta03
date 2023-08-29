import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../design_system/component/snippet.dart';

class GoogleMapClass extends StatefulWidget {
  const GoogleMapClass({super.key});

  @override
  State<GoogleMapClass> createState() => _GoogleMapClassState();
}

class _GoogleMapClassState extends State<GoogleMapClass> {
  late GoogleMapController mapController;
  late Future<Position> currentPosition;

  LatLng currentLatLng = const LatLng(37.5101, 126.8788);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    currentLatLng = position.target;
  }

  @override
  void initState() {
    super.initState();
    currentPosition = Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low, forceAndroidLocationManager: true)
        .then((position) {
      setState(() {
        currentLatLng = LatLng(position.latitude, position.longitude);
      });
      return position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: currentPosition,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Snippet.showWaitSign();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final position = snapshot.data;
          final LatLng currentLatLng = LatLng(position!.latitude, position.longitude);
          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: currentLatLng, // Use the obtained LatLng
              zoom: 15.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("current"),
                position: currentLatLng,
                draggable: true,
                onDragEnd: (value) {},
              ),
              const Marker(
                markerId: MarkerId("Seoul"),
                position: LatLng(37.5519, 126.9918),
                infoWindow: InfoWindow(
                  title: "Seoul",
                  snippet: "Capital of South Korea",
                ), // InfoWindow
              ),
            },
            onCameraMove: _onCameraMove,
          );
        }
      },
    );
  }
}
