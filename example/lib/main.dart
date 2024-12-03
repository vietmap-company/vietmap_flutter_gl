import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_gl_platform_interface/vietmap_gl_platform_interface.dart';
import 'dart:math' show Random;

import 'map_demo.dart';

void main() {
  runApp(MaterialApp(home: VietmapExampleMapView()));
}

class VietmapExampleMapView extends StatefulWidget {
  const VietmapExampleMapView({Key? key}) : super(key: key);

  @override
  State<VietmapExampleMapView> createState() => _VietmapExampleMapViewState();
}

class _VietmapExampleMapViewState extends State<VietmapExampleMapView>
    with TickerProviderStateMixin {
  VietmapController? _mapController;
  List<Marker> temp = [];
  UserLocation? userLocation;
  bool isVector = true;
  late RouteSimulator routeSimulator;
  LatLng? currentLatLng;
  String styleString =
      "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=YOUR_API_KEY_HERE";
  void _onMapCreated(VietmapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {},
      child: Scaffold(
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
            doubleClickZoomEnabled: false,
            myLocationTrackingMode: MyLocationTrackingMode.TrackingCompass,
            myLocationRenderMode: MyLocationRenderMode.COMPASS,
            // styleString: YOUR_STYLE_URL_HERE,
            // styleString:
            //     "https://maps.vietmap.vn/api/maps/raster/styles.json?apikey=YOUR_API_KEY_HERE",
            styleString: styleString,
            trackCameraPosition: true,
            onMapCreated: _onMapCreated,

            compassEnabled: false,

            onMapRenderedCallback: () {},
            onMapFirstRenderedCallback: () async {},
            // onUserLocationUpdated: (location) {
            //   print(location.horizontalAccuracy);
            //   // setState(() {
            //   //   userLocation = location;
            //   //   print(location.latitude);
            //   //   print(location.heading?.trueHeading);
            //   // });
            // },
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
              : UserLocationLayer(
                  mapController: _mapController!,
                  locationIcon: Icon(
                    Icons.circle,
                    color: Colors.blue,
                    size: 50,
                  ),
                  bearingIcon: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.red,
                      size: 15,
                    ),
                  ),
                  ignorePointer: true,
                ),
          _mapController == null || currentLatLng == null
              ? SizedBox.shrink()
              : MarkerLayer(
                  ignorePointer: true,
                  mapController: _mapController!,
                  markers: [
                      Marker(
                          alignment: Alignment.bottomCenter,
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.car_repair_rounded,
                            size: 50,
                            color: Colors.black,
                          ),
                          latLng: currentLatLng!),
                    ]),
          _mapController == null
              ? SizedBox.shrink()
              : ClusterLayer(
                  customClusterWidget: {
                    5: GestureDetector(
                        onTap: () => _mapController!
                            .animateCamera(CameraUpdate.zoomIn()),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                        )),
                    3: GestureDetector(
                        onTap: () => _mapController!
                            .animateCamera(CameraUpdate.zoomIn()),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                        )),
                    2: GestureDetector(
                        onTap: () => _mapController!
                            .animateCamera(CameraUpdate.zoomIn()),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                        )),
                    7: GestureDetector(
                        onTap: () => _mapController!
                            .animateCamera(CameraUpdate.zoomIn()),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                        )),
                  },
                  ignorePointer: false,
                  clusterTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  mapController: _mapController!,
                  markers: [
                    Marker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: Icon(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.759305, 106.675912)),
                    Marker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: Icon(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.769305, 106.685912)),
                    Marker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: Icon(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.749305, 106.665912)),
                    Marker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: Icon(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.859305, 106.575912)),
                    Marker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: Icon(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.756305, 106.674912)),
                    Marker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: Icon(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.848716, 106.545787)),
                    Marker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: Icon(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.834112, 106.588320)),
                    Marker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: Icon(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.816518, 106.547250)),
                    Marker(
                        width: 50,
                        height: 50,
                        // bearing: 40.93711606958891 + 97,

                        child: Icon(Icons.arrow_upward_rounded),
                        latLng: LatLng(10.783842, 106.553342)),
                  ]),
          // _mapController == null
          //     ? SizedBox.shrink()
          //     : StaticMarkerLayer(
          //         ignorePointer: true,
          //         mapController: _mapController!,
          //         markers: [
          //             StaticMarker(
          //                 width: 50,
          //                 height: 50,
          //                 // bearing: 40.93711606958891 + 97,
          //                 bearing: 0,
          //                 child: _markerWidget(Icons.arrow_upward_outlined),
          //                 latLng: LatLng(10.759305, 106.675912)),
          //           ]),
          // _mapController == null
          //     ? SizedBox.shrink()
          //     : MarkerLayer(
          //         ignorePointer: true,
          //         mapController: _mapController!,
          //         markers: temp),
        ]),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                heroTag: 'btn1',
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
              heroTag: 'btn2',
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
              heroTag: 'btn3',
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
              heroTag: 'btn4',
              onPressed: () async {
                var latLngList = VietmapPolylineDecoder.decodePolyline(
                    '}s{`Ac_hjSjAkCFQRu@Lu@F_@D]Ng@ZaALa@JY~AoDDEmBiBe@[WMg@M_@KmA]uA_@a@KkA]qA[[Gs@MUE_AKu@Co@Ew@CYAmAGeBKaAEsAKCQMQUGM?KBIFGHCJoBO{@Ck@AQ@MZAJAjAG|ACz@MnCEnAGlBCx@EjA?\\EvAEjBE~@Cr@F?HqBv@DBSDIBAl@HFADAVSD@JLB@h@BDADEDAJ@',
                    false);

                _mapController?.addPolyline(PolylineOptions(
                  geometry: latLngList,
                  polylineColor: Colors.blue,
                  polylineWidth: 14.0,
                  polylineJoin: "round",
                ));
                List<LatLng> listData = [];
                Line? lineDrive;
                _mapController?.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(10.800499, 106.708610),
                        zoom: 14.5,
                        tilt: 0)));

                RouteSimulator routeSimulator =
                    RouteSimulator(latLngList, this, onLocationChange: (p0) {
                  print(p0.latitude);
                  print(p0.longitude);
                }, duration: Duration(seconds: 5), repeat: false);

                print(routeSimulator.getAnimationController.isCompleted);

                lineDrive = await _mapController?.addPolyline(PolylineOptions(
                  geometry: latLngList,
                  polylineColor: Colors.black,
                  polylineWidth: 2.0,
                ));
                routeSimulator.addV2Listener((LatLng? latLng, int? index,
                        double? distance, LatLng? previousLatLng) =>
                    this.setState(() {
                      listData.clear();
                      int i = 0;
                      listData = latLngList.where((element) {
                        return i++ <= index!;
                      }).toList();
                      if (latLng != null) {
                        listData.add(latLng);
                        currentLatLng = latLng;
                        if (lineDrive != null && listData.length >= 2)
                          _mapController?.updatePolyline(
                              lineDrive,
                              PolylineOptions(
                                geometry: listData,
                                polylineColor: Colors.red,
                                polylineWidth: 14.0,
                                polylineJoin: "round",
                              ));
                      }
                    }));
                routeSimulator.start();
                this.setState(() {
                  this.routeSimulator = routeSimulator;
                });
              },
              child: Icon(Icons.animation),
            ),
            FloatingActionButton(
              heroTag: 'btn5',
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
              heroTag: 'btn6',
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
              heroTag: 'btn7',
              tooltip: 'Remove all',
              onPressed: () {
                routeSimulator.stop();
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
              heroTag: 'btn8',
              tooltip: 'Recenter',
              onPressed: () {
                _mapController?.recenter();
              },
              child: Icon(Icons.center_focus_strong),
            ),
            FloatingActionButton(
              heroTag: 'btn9',
              tooltip: 'Change Style',
              onPressed: () {
                if (isVector) {
                  isVector = false;
                  _mapController?.setStyle(
                      "https://maps.vietmap.vn/api/maps/google-satellite/styles.json?apikey=YOUR_API_KEY_HERE",
                      keepExistingAnnotations: true);
                } else {
                  isVector = true;
                  _mapController?.setStyle(
                      "https://maps.vietmap.vn/api/maps/google/styles.json?apikey=YOUR_API_KEY_HERE");
                }
              },
              child: Icon(Icons.center_focus_strong),
            ),
          ],
        ),
      ),
    );
  }
}
