import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_gl_example/page.dart';

const apiKey = "YOUR-API-KEY";

enum OfflineDataState { unknown, downloaded, downloading, notDownloaded }

class MapClusteringPage extends ExamplePage {
  MapClusteringPage() : super(const Icon(Icons.map), 'MapClusteringPage');

  @override
  Widget build(BuildContext context) {
    return const MapPage();
  }
}

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Map();
  }
}

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State createState() => MapState();
}

class MapState extends State<Map> {
  VietmapController? mapController;
  static const clusterLayer = "clusters";
  static const unClusteredPointLayer = "un-clustered-point";

  OfflineDataState offlineDataState = OfflineDataState.unknown;
  double? downloadProgress;

  @override
  void dispose() {
    mapController?.onFeatureTapped.remove(_onFeatureTapped);
    super.dispose();
  }

  void _onMapCreated(VietmapController controller) async {
    mapController = controller;

    // Event listener that fires for the cluster layer (not due to an explicit
    // filter; only a consequence of the current mix of layers used).
    controller.onFeatureTapped.add(_onFeatureTapped);

    // Determine if we have data stored offline. Note that this is a fairly
    // crude check, and if you are dealing with multiple styles or regions,
    // you will want to do something a bit more advanced.
    final result = await getListOfRegions();
    setState(() {
      if (result.isEmpty) {
        offlineDataState = OfflineDataState.notDownloaded;
      } else {
        offlineDataState = OfflineDataState.downloaded;
      }
    });
  }

  void _onStyleLoadedCallback() async {
    const sourceId = "locations";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Style loaded"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 1),
    ));

    // Alternate form when using hard-coded local data; load this however you like
    // await addClusteredPointSource(sourceId, {
    //   "type": "FeatureCollection",
    //   "features": [
    //     {
    //       "type": "Feature",
    //       "geometry": {
    //         "type": "Point",
    //         "coordinates": [-77.03238901390978, 38.913188059745586]
    //       },
    //       "properties": {"title": "Washington, DC"}
    //     },
    //     {
    //       "type": "Feature",
    //       "geometry": {
    //         "type": "Point",
    //         "coordinates": [-122.414, 37.776]
    //       },
    //       "properties": {"title": "San Francisco"}
    //     }
    //   ]
    // });
    await addClusteredPointSource(sourceId,
        "https://docs.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson");
    await addClusteredPointLayers(sourceId);
  }

  // Logic for interacting with clusters on iOS.
  // See bug report: https://github.com/m0nac0/flutter-maplibre-gl/issues/160
  void _onFeatureTapped(
      dynamic featureId, Point<double> point, LatLng coords) async {
    var features = await mapController
        ?.queryRenderedFeatures(point: point, layerIds: [clusterLayer]);
    if (features?.isNotEmpty ?? false) {
      // Naive zoom += 2. There is a `getClusterExpansionZoom` method
      // on sources, but the Flutter wrapper does not actually expose
      // sources at the moment so we're just falling back to a simple
      // approach.
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(
          coords, mapController!.cameraPosition!.zoom + 2));
    }
  }

  // This method handles interaction with the actual earthquake points on iOS.
  // See bug report: https://github.com/m0nac0/flutter-maplibre-gl/issues/160
  void _onMapClick(Point<double> point, LatLng coordinates) async {
    var messenger = ScaffoldMessenger.of(context);
    var color = Theme.of(context).primaryColor;

    var features = await mapController?.queryRenderedFeatures(
        point: point, layerIds: [unClusteredPointLayer]);
    if (features?.isNotEmpty ?? false) {
      var feature = HashMap.from(features!.first);
      messenger.showSnackBar(SnackBar(
        content: Text("Magnitude ${feature["properties"]["mag"]} earthquake"),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ));
    }
  }

  // Adds a data source to the map via a GeoJSON layer. The data is assumed
  // to be a PointCollection
  Future<void>? addClusteredPointSource(String sourceId, Object? data) {
    return mapController?.addSource(
        sourceId, GeojsonSourceProperties(data: data, cluster: true));
  }

  Future<void> addClusteredPointLayers(String sourceId) async {
    await mapController?.addCircleLayer(
        sourceId,
        clusterLayer,
        const CircleLayerProperties(circleColor: [
          "step",
          ["get", "point_count"],
          "#51bbd6",
          100,
          "#f1f075",
          750,
          "#f28cb1"
        ], circleRadius: [
          "step",
          ["get", "point_count"],
          20,
          100,
          30,
          750,
          40
        ]),
        filter: ["has", "point_count"]);

    await mapController?.addSymbolLayer(
        sourceId,
        "cluster-count",
        const SymbolLayerProperties(
            // NOTE: I would expect to be able to do something like "{point_count_abbreviated}", but this breaks on Android
            textField: [Expressions.get, "point_count_abbreviated"],
            textFont: ["Open Sans Regular"]),
        filter: ["has", "point_count"]);

    await mapController?.addCircleLayer(
        sourceId,
        unClusteredPointLayer,
        const CircleLayerProperties(
            circleColor: "#11b4da",
            circleRadius: 8,
            circleStrokeWidth: 1,
            circleStrokeColor: "#fff"),
        filter: [
          "!",
          ["has", "point_count"]
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VietmapGL(
        styleString: _mapStyleUrl(),
        myLocationEnabled: true,
        initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoadedCallback,
        onMapClick: _onMapClick,
        trackCameraPosition: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  String _mapStyleUrl() {
    return "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=YOUR_API_KEY_HERE";
  }
}
