import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class MarkerWidget extends StatefulWidget {
  final Point initialPosition;
  final LatLng coordinate;
  final void Function(MarkerState) addMarkerState;
  final Widget child;
  MarkerWidget(
      {required String key,
      required this.coordinate,
      required this.initialPosition,
      required this.addMarkerState,
      required this.child})
      : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = MarkerState(initialPosition);
    addMarkerState(state);
    return state;
  }
}

class MarkerState extends State with TickerProviderStateMixin {
  final _iconSize = 20.0;

  Point _position;

  late AnimationController _controller;


  MarkerState(this._position);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ratio = 1.0;

    //web does not support Platform._operatingSystem
    if (!kIsWeb) {
      // iOS returns logical pixel while Android returns screen pixel
      ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
    }

    return Positioned(
        left: _position.x / ratio - _iconSize / 2,
        top: _position.y / ratio - _iconSize / 2,
        child: getChild());
  }

  void updatePosition(Point<num> point) {
    setState(() {
      _position = point;
    });
  }

  LatLng getCoordinate() {
    return (widget as MarkerWidget).coordinate;
  }

  Widget getChild() {
    return (widget as MarkerWidget).child;
  }
}
