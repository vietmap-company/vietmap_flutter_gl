import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../vietmap_flutter_gl.dart';
import '../components/marker.dart';
import '../models/marker_model.dart';

class MarkerLayer extends StatefulWidget {
  final List<Marker> markers;
  final VietmapController mapController;
  final bool? ignorePointer;
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

  @override
  void didUpdateWidget(covariant MarkerLayer oldWidget) {
    var param = <LatLng>[];
    for (var i = 0; i < widget.markers.length; i++) {
      param.add(widget.markers[i].latLng);
    }
    _markers.clear();
    _markerStates.clear();
    _mapController.toScreenLocationBatch(param).then((value) {
      for (var i = 0; i < widget.markers.length; i++) {
        var point = Point<double>(value[i].x as double, value[i].y as double);
        _addMarker(point, widget.markers[i]);
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _mapController.getPlatform.onCameraIdlePlatform.add((cameraPosition) {
      _updateMarkerPosition();
    });
    _mapController.addListener(() {
      if (_mapController.isCameraMoving) {
        _updateMarkerPosition();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Platform.isIOS) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      var param = <LatLng>[];
      for (var i = 0; i < widget.markers.length; i++) {
        param.add(widget.markers[i].latLng);
      }

      _mapController.toScreenLocationBatch(param).then((value) {
        for (var i = 0; i < widget.markers.length; i++) {
          var point = Point<double>(value[i].x as double, value[i].y as double);
          _addMarker(point, widget.markers[i]);
        }
      });
    });

    super.initState();
  }

  void _updateMarkerPosition() {
    final coordinates = <LatLng>[];

    for (final markerState in _markerStates) {
      coordinates.add(markerState.getCoordinate());
    }

    _mapController.toScreenLocationBatch(coordinates).then((points) {
      _markerStates.asMap().forEach((i, value) {
        _markerStates[i].updatePosition(points[i]);
      });
    });
  }

  void _addMarker(Point<double> point, Marker markerModel) {
    setState(() {
      _markers.add(MarkerWidget(
        key: (_rnd.nextInt(100000) +
                markerModel.latLng.latitude +
                markerModel.latLng.longitude)
            .toString(),
        coordinate: markerModel.latLng,
        initialPosition: point,
        addMarkerState: _addMarkerStates,
        child: markerModel.child,
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
