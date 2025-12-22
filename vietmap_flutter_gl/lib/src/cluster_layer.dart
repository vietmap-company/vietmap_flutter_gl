part of '../vietmap_flutter_gl.dart';

class ClusterLayer extends StatefulWidget {
  final List<Marker> markers;
  final VietmapController mapController;

  /// Custom cluster widget for each cluster point
  /// The key of the map is the number of points in the cluster
  /// The value of the map is the widget that will be displayed in the cluster
  /// You must provide values for [2] for the cluster to work properly
  final Map<int, Widget> customClusterWidget;

  /// Set this value to true to ignore pointer events on the markers.
  /// If you using a marker like a button and have a [GestureDetector] inside it,
  /// set this value to false to prevent the map from receiving the gesture.
  final bool? ignorePointer;
  final bool isShowClusterPointCount;
  final TextStyle clusterTextStyle;

  /// The markers to be placed on the map.
  /// use [ClusterLayer] inside a [Stack], that contain [VietmapGL] and [ClusterLayer] to work properly
  /// [VietmapGL.trackCameraPosition] must be set to true to work properly
  const ClusterLayer(
      {super.key,
      this.clusterTextStyle = const TextStyle(color: Colors.white),
      this.isShowClusterPointCount = true,
      required this.customClusterWidget,
      required this.markers,
      required this.mapController,
      this.ignorePointer});

  @override
  State<ClusterLayer> createState() => _ClusterLayerState();
}

class _ClusterLayerState extends State<ClusterLayer> {
  VietmapController get _mapController => widget.mapController;
  List<MarkerWidget> _markers = [];
  List<MarkerWidget> _cluster = [];
  List<MarkerState> _markerStates = [];
  List<MarkerState> _clusterStates = [];
  final Random _rnd = Random();
  late Size size;
  late SuperclusterMutable<Marker> superCluster;

  List<int> get sortedKeys =>
      widget.customClusterWidget.keys.toList()..sort((a, b) => b.compareTo(a));
  @override
  void didUpdateWidget(covariant ClusterLayer oldWidget) {
    _clusterCalculate();
    super.didUpdateWidget(oldWidget);
  }

  _clusterCalculate() {
    final zoom = _mapController._cameraPosition?.zoom ?? 0;
    final visibleMarkers = <Marker>[];
    final clusters = <MutableLayerCluster<Marker>>[];
    _mapController.getVisibleRegion().then((boundingBox) {
      final clustersAndMarker = superCluster
          .search(
              boundingBox.southwest.longitude,
              boundingBox.southwest.latitude,
              boundingBox.northeast.longitude,
              boundingBox.northeast.latitude,
              zoom.round())
          .toList();

      for (var i = 0; i < clustersAndMarker.length; i++) {
        if (clustersAndMarker.elementAt(i) is MutableLayerPoint<Marker>) {
          visibleMarkers.add(
              (clustersAndMarker.elementAt(i) as MutableLayerPoint<Marker>)
                  .originalPoint);
        } else if (clustersAndMarker.elementAt(i)
            is MutableLayerCluster<Marker>) {
          final cluster =
              clustersAndMarker.elementAt(i) as MutableLayerCluster<Marker>;
          clusters.add(cluster);
        }
      }
      _updateMarker(visibleMarkers);
      _updateCluster(clusters);
    });
  }

  _updateMarker(List<Marker> visibleMarkers) {
    final param = <LatLng>[];
    for (var i = 0; i < visibleMarkers.length; i++) {
      param.add(visibleMarkers[i].latLng);
    }
    final newMarker = <MarkerWidget>[];
    final newMarkerStates = <MarkerState>[];
    final newMarkerKey = <String, bool>{};
    _mapController.toScreenLocationBatch(param).then((value) async {
      if (Platform.isAndroid) {
        await Future.delayed(const Duration(milliseconds: 20));
      }
      if (value.isEmpty || visibleMarkers.isEmpty) {
      } else {
        final points = <List<double>>[];
        for (var i = 0; i < visibleMarkers.length; i++) {
          final point =
              Point<double>(value[i].x as double, value[i].y as double);
          points.add([point.x, point.y]);
          var key = _rnd.nextInt(100000).toString() +
              visibleMarkers[i].latLng.latitude.toString() +
              visibleMarkers[i].latLng.longitude.toString();
          if (!newMarkerKey.containsKey(key)) {
            newMarkerKey[key] = true;
          } else {
            key += '.';
            newMarkerKey[key] = true;
          }

          newMarker.add(MarkerWidget(
            key: key,
            coordinate: visibleMarkers[i].latLng,
            initialPosition: point,
            addMarkerState: (_) {
              newMarkerStates.add(_);
            },
            width: visibleMarkers[i].width,
            height: visibleMarkers[i].height,
            alignment: visibleMarkers[i].alignment,
            child: visibleMarkers[i].child,
          ));
        }
      }
      setState(() {
        _markers = newMarker;
        _markerStates = newMarkerStates;
      });
    });
  }

  _updateCluster(List<MutableLayerCluster<Marker>> clusters) {
    final param = <LatLng>[];
    for (var i = 0; i < clusters.length; i++) {
      param.add(LatLng(clusters[i].latitude, clusters[i].longitude));
    }
    final newMarker = <MarkerWidget>[];
    final newMarkerStates = <MarkerState>[];
    final newMarkerKey = <String, bool>{};
    _mapController.toScreenLocationBatch(param).then((value) async {
      if (Platform.isAndroid) {
        await Future.delayed(const Duration(milliseconds: 20));
      }
      if (value.isEmpty || clusters.isEmpty) {
      } else {
        final points = <List<double>>[];
        for (var i = 0; i < clusters.length; i++) {
          final point =
              Point<double>(value[i].x as double, value[i].y as double);
          points.add([point.x, point.y]);
          var key = _rnd.nextInt(100000).toString() +
              clusters[i].latitude.toString() +
              clusters[i].longitude.toString();
          if (!newMarkerKey.containsKey(key)) {
            newMarkerKey[key] = true;
          } else {
            key += '.';
            newMarkerKey[key] = true;
          }

          newMarker.add(MarkerWidget(
            key: key,
            coordinate: LatLng(clusters[i].latitude, clusters[i].longitude),
            initialPosition: point,
            addMarkerState: (_) {
              newMarkerStates.add(_);
            },
            width: 30,
            height: 30,
            child: Stack(
              alignment: Alignment.center,
              children: [
                getNearestBottomValue(clusters[i].childPointCount),
                if (widget.isShowClusterPointCount)
                  Text(
                    clusters[i].childPointCount.toString(),
                    style: widget.clusterTextStyle,
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ));
        }
      }
      setState(() {
        _cluster = newMarker;
        _clusterStates = newMarkerStates;
      });
    });
  }

  Function()? onMapListener;
  Function(CameraPosition?)? onClusterLayerListener;
  @override
  void initState() {
    superCluster = SuperclusterMutable<Marker>(
      getX: (p) => p.latLng.longitude,
      getY: (p) => p.latLng.latitude,
    )..load(widget.markers);
    onMapListener = () {
      if (_mapController.isCameraMoving) {
        _clusterCalculate();
        _updateMarkerPosition();
        _updateClusterPosition();
      }
    };
    onClusterLayerListener = (cameraPosition) {
      _clusterCalculate();
      _updateMarkerPosition();
      _updateClusterPosition();
    };
    _mapController.getPlatform.onCameraIdlePlatform
        .add(onClusterLayerListener!);
    _mapController.addListener(onMapListener!);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Platform.isIOS) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      _clusterCalculate();
    });

    super.initState();
  }

  @override
  void dispose() {
    _mapController.getPlatform.onCameraIdlePlatform
        .remove(onClusterLayerListener!);
    _mapController.removeListener(onMapListener!);
    super.dispose();
  }

  void _updateMarkerPosition() {
    final coordinates = <LatLng>[];

    for (final markerState in _markerStates) {
      coordinates.add(markerState.getCoordinate());
    }

    _mapController.toScreenLocationBatch(coordinates).then((points) async {
      if (Platform.isAndroid) {
        await Future.delayed(const Duration(milliseconds: 20));
      }
      _markerStates.asMap().forEach((i, value) {
        if (points.length > i && _markerStates.length > i) {
          _markerStates[i].updatePosition(points[i], 0);
        }
      });
    });
  }

  void _updateClusterPosition() {
    final coordinates = <LatLng>[];

    for (final markerState in _clusterStates) {
      coordinates.add(markerState.getCoordinate());
    }

    _mapController.toScreenLocationBatch(coordinates).then((points) async {
      if (Platform.isAndroid) {
        await Future.delayed(const Duration(milliseconds: 20));
      }
      _clusterStates.asMap().forEach((i, value) {
        if (points.length > i && _clusterStates.length > i) {
          _clusterStates[i].updatePosition(points[i], 0);
        }
      });
    });
  }

  Widget getNearestBottomValue(int input) {
    // Get all keys and sort them in descending order

    // Find the nearest smaller or equal key
    for (final key in sortedKeys) {
      if (key <= input) {
        return widget.customClusterWidget[key] ?? const SizedBox.shrink();
      }
    }

    // If no such key is found, return null or handle it appropriately
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.ignorePointer ?? false,
      child: Stack(
        children: [..._markers, ..._cluster],
      ),
    );
  }
}
