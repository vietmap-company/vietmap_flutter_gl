import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_gl_example/page.dart';
import 'package:vietmap_gl_platform_interface/vietmap_gl_platform_interface.dart';

import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';

class DriverTrackingPage extends ExamplePage {
  DriverTrackingPage()
      : super(const Icon(Icons.map), 'Driver tracking example');

  @override
  Widget build(BuildContext context) {
    return const DriverTracking();
  }
}

class DriverTracking extends StatefulWidget {
  const DriverTracking({Key? key}) : super(key: key);

  @override
  State<DriverTracking> createState() => _DriverTrackingState();
}

class _DriverTrackingState extends State<DriverTracking>
    with TickerProviderStateMixin {
  VietmapController? vietmapController;
  VietMapRoutingModel? route;
  Line? _routeLine;
  Marker? _storeMarker;
  Marker? _customerMarker;
  LatLng? _driverLatLng = LatLng(10.757549832396515, 106.65865699447431);
  double _driverBearing = 0;
  RouteSimulator? routeSimulator;
  LatLng? lastDriverLocation;
  @override
  void initState() {
    Vietmap.getInstance('YOUR_API_KEY_HERE');
    _startListenGPS();
    super.initState();
  }

  _startListenGPS() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
    var bearing = 0.0;
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (lastDriverLocation != null) {
        bearing = VietmapPolyline.calculateFinalBearing(lastDriverLocation!,
            LatLng(position!.latitude, position.longitude));
      }
      LatLng driverLocation = LatLng(position!.latitude, position.longitude);
      _updateDriverLocation(bearing, driverLocation);
      lastDriverLocation = driverLocation;
      if (vietmapController != null) {
        vietmapController?.moveCamera(CameraUpdate.newLatLng(driverLocation));
      }
      print(
          '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _simulateDriverLocation();
        },
        child: Icon(Icons.start),
      ),
      body: Stack(
        children: [
          VietmapGL(
            trackCameraPosition: true,
            onMapCreated: (controller) {
              vietmapController = controller;
            },
            onMapRenderedCallback: () async {
              _drawStoreMarker();
              _drawUserMarker();
              await _fetchRoute();
            },
            initialCameraPosition: const CameraPosition(
                target: LatLng(10.757549832396515, 106.65865699447431),
                zoom: 10),
            styleString: Vietmap.getVietmapStyleUrl(),
          ),
          if (vietmapController != null && _driverLatLng != null)
            StaticMarkerLayer(
                markers: [_driverMarker], mapController: vietmapController!),
          if (vietmapController != null &&
              _storeMarker != null &&
              _customerMarker != null)
            MarkerLayer(
                markers: [_storeMarker!, _customerMarker!],
                mapController: vietmapController!),
        ],
      ),
    );
  }

  /// This function uses the RouteSimulator to simulate the driver's location,
  /// which is moving along the route. Please call the [_updateDriverLocation]
  /// function for production.
  _simulateDriverLocation() {
    vietmapController
        ?.moveCamera(CameraUpdate.newLatLngZoom(_driverLatLng!, 16));
    if (route?.paths?.isNotEmpty != true) throw 'Not found route';

    /// Create the simulator, modify the upperBound and duration to change the speed & time of the driver
    routeSimulator = RouteSimulator(
        route?.paths?.first.pointsLatLng ?? [], this,
        upperBound: 2.2, duration: const Duration(seconds: 19), repeat: false);
    routeSimulator!.addV2Listener((LatLng? latLng, int? index, double? distance,
            LatLng? previousLatLng) =>
        setState(() {
          if (latLng != null) {
            _driverLatLng = latLng;

            if (previousLatLng != null) {
              /// This code just for mock location,
              /// replace with your own driver bearing
              _driverBearing =
                  VietmapPolyline.calculateFinalBearing(previousLatLng, latLng);
            }

            /// NOTE: - Update the route line on the map here
            List<LatLng> remainingRoute = VietMapSnapEngine.getRouteRemaining(
                route?.paths?.first.pointsLatLng ?? [], latLng);
            _updateTheRouteOnMap(remainingRoute, latLng);
            _checkAndNotifyCustomer(
                route?.paths?.first.pointsLatLng ?? [], latLng);
            _checkIsDriverOffRoute(
                route?.paths?.first.pointsLatLng ?? [], latLng);
            vietmapController?.animateCamera(CameraUpdate.newLatLng(latLng),
                duration: const Duration(milliseconds: 100));
          }
        }));

    /// Start the simulator, will mock the driver's location moving along the route
    routeSimulator!.start();
  }

  // ignore: unused_element
  _updateDriverLocation(double bearing, LatLng driverLocation) {
    setState(() {
      _driverBearing = bearing;
      _driverLatLng = driverLocation;
    });

    List<LatLng> remainingRoute = VietMapSnapEngine.getRouteRemaining(
        route?.paths?.first.pointsLatLng ?? [], driverLocation);
    _updateTheRouteOnMap(remainingRoute, driverLocation);
    _checkAndNotifyCustomer(
        route?.paths?.first.pointsLatLng ?? [], driverLocation);
    _checkIsDriverOffRoute(
        route?.paths?.first.pointsLatLng ?? [], driverLocation);
  }

  _checkIsDriverOffRoute(List<LatLng> route, LatLng latLng) async {
    bool isDriverOffRoute = VietMapSnapEngine.isUserOffRoute(route, latLng);
    if (isDriverOffRoute) {
      /// NOTE: - Notify the driver that he is off route
      /// fetch the new route and update the route line on the map, then continue
      /// calculating the driver's location with the new route.
    }
  }

  _updateTheRouteOnMap(List<LatLng> route, LatLng latLng) {
    if (_routeLine != null) {
      vietmapController?.updatePolyline(
          _routeLine!,
          PolylineOptions(
              geometry: route, polylineColor: Colors.red, polylineWidth: 5));
    }
  }

  _checkAndNotifyCustomer(List<LatLng> route, LatLng latLng) {
    /// Check if the driver is near the customer and send notify.
    double distanceRemaining =
        VietMapSnapEngine.distanceToEndOfRoute(route, latLng);

    if (distanceRemaining < 200) {
      // NOTE: - Notify the customer here
      log(distanceRemaining.toString());
      log('Alert for the customer to prepare for the delivery');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Alert'),
                content:
                    Text('Alert for the customer to prepare for the delivery'),
              ));
      routeSimulator?.stop();
    }
  }

  _fetchRoute() async {
    var res = await Vietmap.routing(VietMapRoutingParams(points: [
      LatLng(10.757549832396515, 106.65865699447431),
      LatLng(10.759095569892626, 106.67595646986068)
    ]));
    res.fold((l) {
      throw l;
    }, (r) {
      setState(() {
        route = r;
      });
      _drawRoute();
      return r;
    });
  }

  _drawStoreMarker() {
    setState(() {
      _storeMarker = Marker(
        width: 50,
        height: 50,
        child: IgnorePointer(
            child: Image.asset(
          'assets/store_marker.png',
          width: 50,
          height: 50,
        )),
        alignment: Alignment.bottomCenter,
        latLng: LatLng(10.757549832396515, 106.65865699447431),
      );
    });
  }

  _drawUserMarker() {
    setState(() {
      _customerMarker = Marker(
          width: 50,
          height: 50,
          child: IgnorePointer(
              child: Image.asset(
            'assets/user_marker.png',
            width: 50,
            height: 50,
          )),
          alignment: Alignment.bottomCenter,
          latLng: LatLng(10.759095569892626, 106.67595646986068));
    });
  }

  _drawRoute() async {
    _routeLine = await vietmapController?.addPolyline(PolylineOptions(
        geometry: route?.paths?.first.pointsLatLng,
        polylineColor: Colors.red,
        polylineWidth: 5));
  }

  StaticMarker get _driverMarker => StaticMarker(
        width: 40,
        height: 50,
        bearing: _driverBearing,
        child: IgnorePointer(
            child: Image.asset(
          'assets/driver.png',
          width: 40,
          height: 50,
        )),
        alignment: Alignment.center,
        latLng: _driverLatLng!,
      );
}
