import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'page.dart';

class ClusterPage extends ExamplePage {
  const ClusterPage({super.key}) : super(const Icon(Icons.map), 'Cluster map');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  VietmapController? mapController;
  var isLight = true;

  _onMapCreated(VietmapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Style loaded :)"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        VietmapGL(
          myLocationEnabled: true,
          logoEnabled: false,
          myLocationTrackingMode: MyLocationTrackingMode.trackingGps,
          trackCameraPosition: true,
          // For mobile
          styleString:
              'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=YOUR_API_KEY_HERE',
          // For web:
          // styleString: 'https://maps.vietmap.vn/mt/tm/style.json?apikey=YOUR_API_KEY_HERE',
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
          onStyleLoadedCallback: _onStyleLoadedCallback,
        ),
        // Add ClusterLayer after VietmapGL
        if (mapController != null)
          ClusterLayer(
            mapController: mapController!,
            customClusterWidget: {
              2: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              5: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '5',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              10: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '10',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            },
            markers: [
              Marker(
                  child: const Icon(Icons.abc),
                  latLng: const LatLng(10.762622, 106.217233)),
              Marker(
                  child: const Icon(Icons.ac_unit),
                  latLng: const LatLng(10.762622, 106.218233)),
              Marker(
                  child: const Icon(Icons.access_alarm),
                  latLng: const LatLng(10.762622, 106.219233)),
              Marker(
                  child: const Icon(Icons.access_time),
                  latLng: const LatLng(10.762022, 106.213233)),
              Marker(
                  child: const Icon(Icons.account_balance),
                  latLng: const LatLng(10.762122, 106.213233)),
              Marker(
                  child: const Icon(Icons.ad_units),
                  latLng: const LatLng(10.762222, 106.213233)),
              Marker(
                  child: const Icon(Icons.add_a_photo),
                  latLng: const LatLng(10.762322, 106.213233)),
              Marker(
                  child: const Icon(Icons.add_alarm),
                  latLng: const LatLng(10.762422, 106.213233)),
              Marker(
                  child: const Icon(Icons.add_box),
                  latLng: const LatLng(10.762522, 106.213233)),
              Marker(
                  child: const Icon(Icons.add_business),
                  latLng: const LatLng(10.762722, 106.213233)),
              Marker(
                  child: const Icon(Icons.add_call),
                  latLng: const LatLng(10.762822, 106.213233)),
              Marker(
                  child: const Icon(Icons.add_chart),
                  latLng: const LatLng(10.762922, 106.213233)),
            ],
          ),
        if (mapController != null)
          MarkerLayer(markers: [
            Marker(
                child: const Icon(Icons.abc),
                latLng: const LatLng(10.762622, 106.213233)),
          ], mapController: mapController!),
        if (mapController != null)
          UserLocationLayer(mapController: mapController!),
      ],
    ));
  }
}
