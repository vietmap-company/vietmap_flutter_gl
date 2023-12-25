import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_gl_platform_interface/vietmap_gl_platform_interface.dart';
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
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: _markerWidget(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.759305, 106.675912)),
                  ]),
        _mapController == null
            ? SizedBox.shrink()
            : StaticMarkerLayer(
                ignorePointer: true,
                mapController: _mapController!,
                markers: [
                    StaticMarker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,
                        bearing: 0,
                        child: _markerWidget(Icons.arrow_upward_outlined),
                        latLng: LatLng(10.759305, 106.675912)),
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
              onPressed: () {
                var nres = VietmapPolylineDecoder.decodePolyline(
                  'y`uoSse~mjEuL_KsFsEeNuL{FqF}CwCgM}L{PgP}A}Aax@vScShF{PpEsHzBmj@tOk]~IyQzE{KtCyKrCmRbF{a@tKc\rIga@nKi`@bKsO`EwRdFyGpAsMX}DeDeDy@mD?eCh@yBjAwBfCcLqGwUgNiF}CuMwHwBqAeFoCcLuG_CqBgQeQ{UaT{HaHgBoBgKqJ{K{KkHaG_GaFsImHuNwLeGuFwBsCkR_W{EoGnOwPxFkGfNoOzP`OvH|FhBvAjCpB|JpHbAr@',
                );
                _mapController?.addPolyline(PolylineOptions(
                  geometry: nres,
                  polylineColor: Colors.red,
                  polylineWidth: 14.0,
                ));
                var eres = VietmapPolylineDecoder.encodePolyline(nres);
                log(eres);
                print(nres);
              },
              child: Icon(Icons.calculate)),
          FloatingActionButton(
            onPressed: () {
              var line = [
                LatLng(10.759197, 106.67581799999999),
                LatLng(10.759416, 106.67601000000002),
                LatLng(10.759538, 106.67611599999998),
                LatLng(10.759781, 106.676335),
                LatLng(10.759907, 106.67645600000003),
                LatLng(10.759986, 106.67653200000001),
                LatLng(10.760214, 106.67675500000001),
                LatLng(10.7605, 106.677031),
                LatLng(10.760546999999999, 106.677078),
                LatLng(10.76146, 106.67674599999998),
                LatLng(10.761782, 106.67662899999999),
                LatLng(10.762068, 106.67652399999997),
                LatLng(10.762222, 106.67646200000001),
                LatLng(10.762917, 106.676195),
                LatLng(10.763403, 106.676019),
                LatLng(10.763703999999999, 106.67590899999999),
                LatLng(10.76391, 106.67583400000001),
                LatLng(10.764115, 106.67575999999997),
                LatLng(10.764426, 106.67564600000003),
                LatLng(10.764984, 106.67544299999997),
                LatLng(10.76521, 106.67544799999996),
                LatLng(10.765758, 106.67524800000001),
                LatLng(10.766290999999999, 106.67505399999999),
                LatLng(10.766556999999999, 106.674957)
              ];
              var pt = LatLng(10.761782, 106.67662899999999);

              var snapped =
                  VietmapPolyline.nearestLatLngOnLine(line, pt, Unit.miles);
              print(snapped?.toJson());
              _mapController?.addPolyline(PolylineOptions(
                geometry: line,
                polylineColor: Colors.black,
                polylineWidth: 14.0,
              ));
              _mapController?.addCircle(CircleOptions(
                  geometry: LatLng(38.878605, -77.031669),
                  circleColor: Colors.orange,
                  circleRadius: 5));
              _mapController?.addCircle(CircleOptions(
                  geometry: LatLng(38.892368, -77.019824),
                  circleColor: Colors.yellow,
                  circleRadius: 5));
              _mapController?.addCircle(CircleOptions(
                  geometry: snapped?.point,
                  circleColor: Colors.red,
                  circleRadius: 5));

              _mapController?.addCircle(CircleOptions(
                  geometry: pt, circleColor: Colors.blue, circleRadius: 5));

              var data = VietmapPolyline.splitRouteByLatLng(line, pt,
                  unit: Unit.miles);

              print(data);
              _mapController?.addPolyline(PolylineOptions(
                geometry: data[0],
                polylineColor: Colors.green,
                polylineWidth: 14.0,
              ));
              _mapController?.addPolyline(PolylineOptions(
                geometry: data[1],
                polylineColor: Colors.black,
                polylineWidth: 14.0,
              ));
            },
            child: Icon(Icons.shape_line_outlined),
          ),
          FloatingActionButton(
            tooltip: 'Add marker',
            onPressed: () {
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
            onPressed: () async {
              var line = await _mapController?.addPolyline(
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
                    polylineOpacity: 1,
                    draggable: true),
              );
              Future.delayed(Duration(seconds: 3)).then((value) {
                if (line != null) {
                  _mapController?.updatePolyline(
                    line,
                    PolylineOptions(
                        geometry: [
                          LatLng(10.736657, 106.672240),
                          LatLng(10.766543, 106.742378),
                          LatLng(10.775818, 106.640497),
                          LatLng(10.727416, 106.735597),
                          LatLng(10.792765, 106.674143),
                          LatLng(10.736657, 106.672240),
                        ],
                        polylineColor: Colors.blue,
                        polylineWidth: 14.0,
                        polylineOpacity: 1,
                        draggable: true),
                  );
                }
              });
            },
            child: Icon(Icons.polyline),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            tooltip: 'Add polygon',
            onPressed: () async {
              var polygon = await _mapController?.addPolygon(
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

              Future.delayed(Duration(seconds: 3)).then((value) {
                if (polygon != null) {
                  _mapController?.updatePolygon(
                    polygon,
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
                        polygonColor: Colors.blue,
                        polygonOpacity: 1,
                        draggable: true),
                  );
                }
              });
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
    return Icon(icon, color: Colors.red, size: 50);
  }
}
