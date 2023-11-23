part of vietmap_flutter_gl;

class MarkerLayer extends StatefulWidget {
  final List<Marker> markers;
  final VietmapController mapController;

  /// Set this value to true to ignore pointer events on the markers.
  /// If you using a marker like a button and have a [GestureDetector] inside it,
  /// set this value to false to prevent the map from receiving the gesture.
  final bool? ignorePointer;

  /// The markers to be placed on the map.
  /// use [MarkerLayer] inside a [Stack], that contain [VietmapGL] and [MarkerLayer] to work properly
  /// [VietmapGL.trackCameraPosition] must be set to true to work properly
  const MarkerLayer(
      {Key? key,
      required this.markers,
      required this.mapController,
      this.ignorePointer})
      : super(key: key);

  @override
  State<MarkerLayer> createState() => _MarkerLayerState();
}

class _MarkerLayerState extends State<MarkerLayer> {
  VietmapController get _mapController => widget.mapController;
  List<MarkerWidget> _markers = [];
  List<MarkerState> _markerStates = [];
  final Random _rnd = new Random();
  late Size size;
  @override
  void didUpdateWidget(covariant MarkerLayer oldWidget) {
    var param = <LatLng>[];
    for (var i = 0; i < widget.markers.length; i++) {
      param.add(widget.markers[i].latLng);
    }
    var _newMarker = <MarkerWidget>[];
    var _newMarkerStates = <MarkerState>[];
    Map<String, bool> _newMarkerKey = {};
    // print('-----------------------------------------------');
    // print(_mapController.cameraPosition?.bearing);
    // print('-----------------------------------------------');
    _mapController.toScreenLocationBatch(param).then((value) {
      if (value.isEmpty || widget.markers.isEmpty) {
      } else {
        for (var i = 0; i < widget.markers.length; i++) {
          var point = Point<double>(value[i].x as double, value[i].y as double);
          String key = _rnd.nextInt(100000).toString() +
              widget.markers[i].latLng.latitude.toString() +
              widget.markers[i].latLng.longitude.toString();
          if (!_newMarkerKey.containsKey(key)) {
            _newMarkerKey[key] = true;
          } else {
            key += '.';
            _newMarkerKey[key] = true;
          }

          _newMarker.add(MarkerWidget(
            key: key,
            coordinate: widget.markers[i].latLng,
            initialPosition: point,
            addMarkerState: (_) {
              _newMarkerStates.add(_);
            },
            child: widget.markers[i].child,
            width: widget.markers[i].width,
            height: widget.markers[i].height,
            alignment: widget.markers[i].alignment,
          ));
        }
      }
      setState(() {
        _markers = _newMarker;
        _markerStates = _newMarkerStates;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  Function()? onMapListener;
  Function(CameraPosition?)? onMarkerLayerListener;
  @override
  void initState() {
    onMapListener = () {
      if (_mapController.isCameraMoving) {
        _updateMarkerPosition(_mapController.cameraPosition);
      }
    };
    onMarkerLayerListener = (cameraPosition) {
      _updateMarkerPosition(cameraPosition);
    };
    _mapController.getPlatform.onCameraIdlePlatform.add(onMarkerLayerListener!);
    _mapController.addListener(onMapListener!);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Platform.isIOS) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      var param = <LatLng>[];
      for (var i = 0; i < widget.markers.length; i++) {
        param.add(widget.markers[i].latLng);
      }

      _mapController.toScreenLocationBatch(param).then((value) {
        if (value.isEmpty || widget.markers.isEmpty) return;
        for (var i = 0; i < widget.markers.length; i++) {
          var point = Point<double>(value[i].x as double, value[i].y as double);
          _addMarker(point, widget.markers[i]);
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _mapController.getPlatform.onCameraIdlePlatform
        .remove(onMarkerLayerListener!);
    _mapController.removeListener(onMapListener!);
    super.dispose();
  }

  void _updateMarkerPosition(CameraPosition? cameraPosition) {
    final coordinates = <LatLng>[];

    for (final markerState in _markerStates) {
      coordinates.add(markerState.getCoordinate());
    }

    _mapController.toScreenLocationBatch(coordinates).then((points) {
      _markerStates.asMap().forEach((i, value) {
        if (points.length > i && _markerStates.length > i) {
          _markerStates[i].updatePosition(points[i], 0);
        }
      });
    });
  }

  void _addMarker(Point<double> point, Marker markerModel) {
    setState(() {
      _markers.add(MarkerWidget(
        key: _rnd.nextInt(100000).toString() +
            markerModel.latLng.latitude.toString() +
            markerModel.latLng.longitude.toString(),
        coordinate: markerModel.latLng,
        initialPosition: point,
        addMarkerState: _addMarkerStates,
        child: markerModel.child,
        width: markerModel.width,
        height: markerModel.height,
        alignment: markerModel.alignment,
      ));
    });
  }

  void _addMarkerStates(MarkerState markerState) {
    _markerStates.add(markerState);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.ignorePointer ?? false,
      child: Stack(
        children: _markers,
      ),
    );
  }
}
