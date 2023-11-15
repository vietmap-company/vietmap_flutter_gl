import 'dart:math';

import 'package:flutter/material.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'page.dart';

class CustomMarkerPage extends ExamplePage {
  CustomMarkerPage() : super(const Icon(Icons.place), 'Custom marker');

  @override
  Widget build(BuildContext context) {
    return CustomMarker();
  }
}

class CustomMarker extends StatefulWidget {
  const CustomMarker({this.listMarker});
  final List<Marker>? listMarker;
  @override
  State createState() => CustomMarkerState();
}

class CustomMarkerState extends State<CustomMarker> {
  VietmapController? _mapController;
  List<Marker> temp = [];
  void _onMapCreated(VietmapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(children: [
        VietmapGL(
          styleString:
              "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=YOUR_API_KEY_HERE",
          trackCameraPosition: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
              target: LatLng(10.739031, 106.680524), zoom: 10),
        ),
        _mapController == null
            ? SizedBox.shrink()
            : MarkerLayer(
                ignorePointer: true,
                mapController: _mapController!,
                markers: [
                    Marker(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                          child: Icon(Icons.abc, color: Colors.red, size: 13),
                        ),
                        latLng: LatLng(10.748076, 106.678434)),
                    Marker(
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                          child: Icon(Icons.zoom_out_sharp,
                              color: Colors.red, size: 13),
                        ),
                        latLng: LatLng(10.766543, 106.742378)),
                    Marker(
                        child: Container(
                          width: 20,
                          alignment: Alignment.center,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                          child: Icon(Icons.zoom_in_map_outlined,
                              color: Colors.red, size: 13),
                        ),
                        latLng: LatLng(10.775818, 106.640497)),
                    Marker(
                        child: Container(
                          width: 20,
                          alignment: Alignment.center,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                          child:
                              Icon(Icons.ac_unit, color: Colors.red, size: 13),
                        ),
                        latLng: LatLng(10.727416, 106.735597)),
                    Marker(
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                          child: Icon(Icons.access_time_outlined,
                              color: Colors.red, size: 13),
                        ),
                        latLng: LatLng(10.792765, 106.674143)),
                  ]),
        _mapController == null
            ? SizedBox.shrink()
            : MarkerLayer(
                ignorePointer: true,
                mapController: _mapController!,
                markers: temp),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (int i = 0; i < 100; i++) {
            Random _rnd = new Random();
            setState(() {
              temp.add(Marker(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.orange),
                    child: Icon(Icons.accessibility_new_rounded,
                        color: Colors.blue, size: 13),
                  ),
                  latLng: LatLng(_rnd.nextInt(90) * 1.0 + _rnd.nextDouble(),
                      _rnd.nextInt(180) * 1.0 + _rnd.nextDouble())));
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
