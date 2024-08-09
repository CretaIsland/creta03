//구글맵 임시로 사용안함.
/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:creta_common/common/creta_snippet.dart';
import 'package:http/http.dart' as http;

import 'google_map_saved_list.dart';

class GoogleMapClass extends StatefulWidget {
  const GoogleMapClass({super.key});

  @override
  State<GoogleMapClass> createState() => _GoogleMapClassState();
}

class _GoogleMapClassState extends State<GoogleMapClass> {
  late GoogleMapController mapController;
  late Future<Position> currentPosition;

  LatLng? currentLatLng;
  // LatLng currentLatLng = const LatLng(37.5101, 126.8788);

  Set<Marker> markers = <Marker>{};
  bool disableCameraMove = false;

  // API Key 는 DB 에서 갖고 와야 한다.
  String apiKey = '';
  AddressManager addressProvider = AddressManager();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    if (currentLatLng != null) currentLatLng = position.target;
  }

  void _onMapTapped(LatLng latLng) {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          onTap: () {
            setState(() {
              markers.removeWhere(
                (marker) {
                  return marker.markerId == MarkerId(latLng.toString());
                },
              );
            });
          },
        ),
      );
    });
  }

  Future<String> getAddressFromLatLng(LatLng latLng, String apiKey) async {
    final lat = latLng.latitude;
    final lng = latLng.longitude;
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey'));

    if (response.statusCode == 200) {
      final jsonResult = json.decode(response.body);
      if (jsonResult['status'] == "OK") {
        final results = jsonResult['results'][0];
        return results['formatted_address'];
      } else {
        return "Address not found";
      }
    } else {
      return "Error: Failed to fetch address";
    }
  }

  // void _onMapTapped(LatLng latLng) async {
  //   Marker? tappedMarker;
  //   String address = await getAddressFromLatLng(latLng, apiKey);
  //   MarkerId markerId = MarkerId(latLng.toString());

  //   setState(() {
  //     tappedMarker = Marker(
  //       markerId: markerId,
  //       position: latLng,
  //       onTap: () {
  //         showDialog(
  //           context: context,
  //           builder: ((context) {
  //             return AlertDialog(
  //               title: const Text("Marker Options"),
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text("Address: $address"),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           print("Save to List: $address");
  //                           addressProvider.addAdress(address);
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: const Text("Save to List"),
  //                       ),
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           print("Remove ${latLng.toString()}");
  //                           markers.remove(tappedMarker!);
  //                           // markers.removeWhere((element) {
  //                           //   return element.markerId == markerId;
  //                           // });
  //                           addressProvider.removeAdress(address);
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: const Text("Remove"),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }),
  //         );
  //       },
  //     );
  //     markers.add(tappedMarker!);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _onCameraMove;
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
          return CretaSnippet.showWaitSign();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final position = snapshot.data;
          final LatLng currentLatLng = LatLng(position!.latitude, position.longitude);
          return GestureDetector(
            onVerticalDragUpdate: (details) {
              if (disableCameraMove) {
                return;
              }
            },
            onHorizontalDragUpdate: (details) {
              return;
            },
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: currentLatLng, // Use the obtained LatLng
                  zoom: 15.0),
              markers: markers,
              // {
              //   Marker(
              //     markerId: const MarkerId("current"),
              //     position: currentLatLng,
              //     draggable: true,
              //     onDragEnd: (value) {},
              //   ),
              //   const Marker(
              //     markerId: MarkerId("Seoul"),
              //     position: LatLng(37.5519, 126.9918),
              //     infoWindow: InfoWindow(
              //       title: "Seoul",
              //       snippet: "Capital of South Korea",
              //     ), // InfoWindow
              //   ),
              // },
              onTap: _onMapTapped,
              onCameraMove: _onCameraMove,
            ),
          );
        }
      },
    );
  }
}
*/