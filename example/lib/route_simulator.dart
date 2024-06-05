import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'package:vietmap_gl_platform_interface/vietmap_gl_platform_interface.dart';
import 'constant.dart';

class RouteSimulatorScreen extends StatefulWidget {
  RouteSimulatorScreen({Key? key}) : super(key: key);
  // const RouteSimulatorScreen({Key? key});
  final Widget leading = Icon(Icons.map);
  final String title = 'Route Simulator';
  @override
  State<RouteSimulatorScreen> createState() => _RouteSimulatorScreenState();
}

class _RouteSimulatorScreenState extends State<RouteSimulatorScreen>
    with TickerProviderStateMixin {
  VietmapController? _mapController;

  late RouteSimulator routeSimulator;
  var isLight = true;

  _onMapCreated(VietmapController controller) {
    _mapController = controller;
  }

  _onStyleLoadedCallback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :)"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // needs different dark and light styles in this repo
      // floatingActionButton: Padding(
      // padding: const EdgeInsets.all(32.0),
      // child: FloatingActionButton(
      // child: Icon(Icons.swap_horiz),
      // onPressed: () => setState(
      // () => isLight = !isLight,
      // ),
      // ),
      // ),
      body: VietmapGL(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
        onStyleLoadedCallback: () => _onStyleLoadedCallback(context),
        myLocationRenderMode: MyLocationRenderMode.GPS,
        myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
        onUserLocationUpdated: (location) {
          print(location.latitude);
        },
        styleString: YOUR_STYLE_URL_HERE,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var latLngList = VietmapPolylineDecoder.decodePolyline(
              '}s{`Ac_hjSjAkCFQRu@Lu@F_@D]Ng@ZaALa@JY~AoDDEmBiBe@[WMg@M_@KmA]uA_@a@KkA]qA[[Gs@MUE_AKu@Co@Ew@CYAmAGeBKaAEsAKCQMQUGM?KBIFGHCJoBO{@Ck@AQ@MZAJAjAG|ACz@MnCEnAGlBCx@EjA?\\EvAEjBE~@Cr@F?HqBv@DBSDIBAl@HFADAVSD@JLB@h@BDADEDAJ@',
              false);
          print(latLngList);

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
                  target: LatLng(10.800499, 106.708610), zoom: 15, tilt: 0)));

          RouteSimulator routeSimulator =
              RouteSimulator(latLngList, this, onLocationChange: (p0) {
            print(p0.latitude);
            print(p0.longitude);
          }, duration: Duration(seconds: 15), repeat: false);

          print(routeSimulator.getAnimationController.isCompleted);

          lineDrive = await _mapController?.addPolyline(PolylineOptions(
            geometry: latLngList,
            polylineColor: Colors.black,
            polylineWidth: 2.0,
          ));
          routeSimulator.addV2Listener((LatLng? latLng, int? index,
                  double? distance, LatLng? recentLatLng) =>
              this.setState(() {
                listData.clear();
                int i = 0;
                listData = latLngList.where((element) {
                  return i++ <= index!;
                }).toList();
                if (latLng != null) {
                  listData.add(latLng);
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
        child: Icon(Icons.route),
      ),
    );
  }
}
