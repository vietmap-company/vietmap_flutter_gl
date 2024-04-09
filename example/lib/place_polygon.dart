// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'constant.dart';
import 'page.dart';

class PlacePolygonPage extends ExamplePage {
  PlacePolygonPage() : super(const Icon(Icons.check_circle), 'Place polygon');

  @override
  Widget build(BuildContext context) {
    return const PlacePolygonBody();
  }
}

class PlacePolygonBody extends StatefulWidget {
  const PlacePolygonBody();

  @override
  State<StatefulWidget> createState() => PlacePolygonBodyState();
}

class PlacePolygonBodyState extends State<PlacePolygonBody> {
  PlacePolygonBodyState();

  static final LatLng center = const LatLng(10.86711, 106.1947171);
  final String _polygonPatternImage = "assets/fill/cat_silhouette_pattern.png";

  final List<List<LatLng>> _defaultGeometry = [
    [
      LatLng(10.719, 106.150),
      LatLng(10.858, 106.150),
      LatLng(10.866, 106.401),
      LatLng(10.747, 106.328),
      LatLng(10.719, 106.150),
    ],
    [
      LatLng(10.762, 106.250),
      LatLng(10.827, 106.250),
      LatLng(10.833, 106.347),
      LatLng(10.762, 106.250),
    ]
  ];

  VietmapController? controller;
  int _polygonCount = 0;
  Polygon? _selectedPolygon;
  bool isSelected = false;

  void _onMapCreated(VietmapController controller) {
    this.controller = controller;
    controller.onPolygonTapped.add(_onPolygonTapped);
    this.controller!.onFeatureDrag.add(_onFeatureDrag);
  }

  void _onFeatureDrag(id,
      {required current,
      required delta,
      required origin,
      required point,
      required eventType}) {
    DragEventType type = eventType;
    switch (type) {
      case DragEventType.start:
        // Handle start drag here
        break;
      case DragEventType.drag:
        // handle drag here.
        break;
      case DragEventType.end:
        // Handle end drag here
        break;
    }
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", _polygonPatternImage);
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  @override
  void dispose() {
    controller?.onPolygonTapped.remove(_onPolygonTapped);
    super.dispose();
  }

  void _onPolygonTapped(Polygon polygon) {
    setState(() {
      _selectedPolygon = polygon;

      isSelected = true;
    });
    print('Polygon selected');
  }

  void _updateSelectedPolygon(PolygonOptions changes) {
    controller!.updatePolygon(_selectedPolygon!, changes);
  }

  void _add() {
    controller!.addPolygon(PolygonOptions(
      geometry: _defaultGeometry,
      polygonColor: Color(0xFFFF0000),
      polygonOutlineColor: Color(0xFFFF0000),
    ));
    setState(() {
      _polygonCount += 1;
    });
  }

  void _remove() {
    controller!.removePolygon(_selectedPolygon!);
    setState(() {
      _selectedPolygon = null;
      _polygonCount -= 1;
    });
  }

  void _changePosition() {
    List<List<LatLng>>? geometry = _selectedPolygon!.options.geometry;

    if (geometry == null) {
      geometry = _defaultGeometry;
    }

    _updateSelectedPolygon(PolygonOptions(
        geometry: geometry
            .map((list) => list
                .map(
                    // Move to right with 0.1 degree on longitude
                    (latLng) => LatLng(latLng.latitude, latLng.longitude + 0.1))
                .toList())
            .toList()));
  }

  void _changeDraggable() {
    bool? draggable = _selectedPolygon!.options.draggable;
    if (draggable == null) {
      // default value
      draggable = false;
    }
    _updateSelectedPolygon(
      PolygonOptions(draggable: !draggable),
    );
  }

  Future<void> _changePolygonOpacity() async {
    double? current = _selectedPolygon!.options.polygonOpacity;
    if (current == null) {
      // default value
      current = 1.0;
    }

    _updateSelectedPolygon(
      PolygonOptions(polygonOpacity: current < 0.1 ? 1.0 : current * 0.75),
    );
  }

  Future<void> _changePolygonColor() async {
    Color? current = _selectedPolygon!.options.polygonColor;
    if (current == null) {
      // default value
      current = Color(0xFFFF0000);
    }

    _updateSelectedPolygon(
      PolygonOptions(polygonColor: Color(0xFF000000)),
    );
  }

  Future<void> _changePolygonOutlineColor() async {
    Color? current = _selectedPolygon!.options.polygonOutlineColor;
    if (current == null) {
      // default value
      current = Color(0xFFFF00FF);
    }

    _updateSelectedPolygon(
      PolygonOptions(polygonOutlineColor: Color(0xFFFFFF00)),
    );
  }

  Future<void> _changePolygonPattern() async {
    String? current =
        _selectedPolygon!.options.polygonPattern == null ? "assetImage" : null;
    _updateSelectedPolygon(
      PolygonOptions(polygonPattern: current),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: VietmapGL(
              styleString: YOUR_STYLE_URL_HERE,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoaded,
              initialCameraPosition: const CameraPosition(
                target: LatLng(10.852, 106.211),
                zoom: 7.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextButton(
                          child: const Text('add'),
                          onPressed: (_polygonCount == 12) ? null : _add,
                        ),
                        TextButton(
                          child: const Text('remove'),
                          onPressed:
                              (_selectedPolygon == null) ? null : _remove,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextButton(
                          child: const Text('change polygon-opacity'),
                          onPressed: (_selectedPolygon == null)
                              ? null
                              : _changePolygonOpacity,
                        ),
                        TextButton(
                          child: const Text('change polygon-color'),
                          onPressed: (_selectedPolygon == null)
                              ? null
                              : _changePolygonColor,
                        ),
                        TextButton(
                          child: const Text('change polygon-outline-color'),
                          onPressed: (_selectedPolygon == null)
                              ? null
                              : _changePolygonOutlineColor,
                        ),
                        TextButton(
                          child: const Text('change polygon-pattern'),
                          onPressed: (_selectedPolygon == null)
                              ? null
                              : _changePolygonPattern,
                        ),
                        TextButton(
                          child: const Text('change position'),
                          onPressed: (_selectedPolygon == null)
                              ? null
                              : _changePosition,
                        ),
                        TextButton(
                          child: const Text('toggle draggable'),
                          onPressed: (_selectedPolygon == null)
                              ? null
                              : _changeDraggable,
                        ),
                        Text(isSelected
                            ? "You selected a polygon"
                            : "No polygon has been selected")
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
