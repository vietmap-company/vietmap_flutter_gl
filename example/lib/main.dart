import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'dart:math' show Random;

import 'constant.dart';
import 'map_demo.dart';

void main() {
  runApp(MaterialApp(home: VietmapExampleMapView()));
}

class VietmapExampleMapView extends StatefulWidget {
  const VietmapExampleMapView({Key? key}) : super(key: key);

  @override
  State<VietmapExampleMapView> createState() => _VietmapExampleMapViewState();
}

class _VietmapExampleMapViewState extends State<VietmapExampleMapView> {
  VietmapController? _mapController;
  List<Marker> temp = [];
  UserLocation? userLocation;
  void _onMapCreated(VietmapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Vietmap Flutter GL'),
          actions: [
            IconButton(
                tooltip: 'Xem ví dụ chi tiết',
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => MapsDemo()));
                },
                icon: Icon(Icons.more))
          ],
          centerTitle: true),
      body: Stack(children: [
        VietmapGL(
          myLocationEnabled: true,
          // myLocationTrackingMode: MyLocationTrackingMode.TrackingCompass,
          // myLocationRenderMode: MyLocationRenderMode.NORMAL,
          styleString: YOUR_STYLE_URL_HERE,
          trackCameraPosition: true,
          onMapCreated: _onMapCreated,
          compassEnabled: false,
          onMapRenderedCallback: () {
            _mapController?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(10.739031, 106.680524),
                    zoom: 10,
                    tilt: 60)));
          },
          onUserLocationUpdated: (location) {
            setState(() {
              userLocation = location;
            });
          },
          initialCameraPosition: const CameraPosition(
              target: LatLng(10.739031, 106.680524), zoom: 2),
          onMapClick: (point, coordinates) async {
            var data =
                await _mapController?.queryRenderedFeatures(point: point);
            log(data.toString());
          },
        ),
        _mapController == null
            ? SizedBox.shrink()
            : MarkerLayer(
                ignorePointer: true,
                mapController: _mapController!,
                markers: [
                    Marker(
                        child: _markerWidget(Icons.abc),
                        latLng: LatLng(10.736657, 106.672240)),
                    Marker(
                        child: _markerWidget(Icons.zoom_out_map),
                        latLng: LatLng(10.766543, 106.742378)),
                    Marker(
                        child: _markerWidget(Icons.access_alarms_rounded),
                        latLng: LatLng(10.775818, 106.640497)),
                    Marker(
                        child: _markerWidget(Icons.account_balance),
                        latLng: LatLng(10.727416, 106.735597)),
                    Marker(
                        child: _markerWidget(Icons.wrong_location),
                        latLng: LatLng(10.792765, 106.674143)),
                  ]),
        _mapController == null
            ? SizedBox.shrink()
            : MarkerLayer(
                ignorePointer: true,
                mapController: _mapController!,
                markers: temp),
      ]),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: 'Add marker',
            onPressed: () {
              print(_mapController?.cameraPosition?.zoom);
              if ((_mapController?.cameraPosition?.zoom ?? 0) > 7) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thu nhỏ bản đồ để xem marker')));
              }
              for (int i = 0; i < 100; i++) {
                Random _rnd = new Random();
                var lat = _rnd.nextInt(90) * 1.0 + _rnd.nextDouble();
                var lng = _rnd.nextInt(180) * 1.0 + _rnd.nextDouble();
                setState(() {
                  temp.add(Marker(
                      alignment: Alignment.bottomCenter,
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                      latLng: LatLng(lat, lng)));
                });
              }
            },
            child: Icon(Icons.add_location_outlined),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            tooltip: 'Add polyline',
            onPressed: () {
              _mapController?.addPolyline(
                PolylineOptions(
                    geometry: [
                      LatLng(10.736657, 106.672240),
                      LatLng(10.766543, 106.742378),
                      LatLng(10.775818, 106.640497),
                      LatLng(10.727416, 106.735597),
                      LatLng(10.792765, 106.674143),
                      LatLng(10.736657, 106.672240),
                    ],
                    polylineColor: Colors.red,
                    polylineWidth: 14.0,
                    polylineOpacity: 0.5,
                    draggable: true),
              );
            },
            child: Icon(Icons.polyline),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            tooltip: 'Add polygon',
            onPressed: () {
              _mapController?.addPolygon(
                PolygonOptions(
                    geometry: [
                      [
                        LatLng(10.736657, 106.672240),
                        LatLng(10.766543, 106.742378),
                        LatLng(10.775818, 106.640497),
                        LatLng(10.727416, 106.735597),
                        LatLng(10.792765, 106.674143),
                        LatLng(10.736657, 106.672240),
                      ]
                    ],
                    polygonColor: Colors.red,
                    polygonOpacity: 0.5,
                    draggable: true),
              );
            },
            child: Icon(Icons.format_shapes_outlined),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            tooltip: 'Remove all',
            onPressed: () {
              _mapController?.clearLines();
              _mapController?.clearPolygons();
              setState(() {
                temp = [];
              });
              print(temp);
            },
            child: Icon(Icons.clear),
          ),
          FloatingActionButton(
            tooltip: 'Remove all',
            onPressed: () {
              _mapController?.recenter();
            },
            child: Icon(Icons.center_focus_strong),
          ),
        ],
      ),
    );
  }

  _markerWidget(IconData icon) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      child: Icon(icon, color: Colors.red, size: 13),
    );
  }
}
