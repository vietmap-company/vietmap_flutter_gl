// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'constant.dart';
import 'page.dart';

class PolylinePage extends ExamplePage {
  PolylinePage() : super(const Icon(Icons.share), 'Line');

  @override
  Widget build(BuildContext context) {
    return const PolylineBody();
  }
}

class PolylineBody extends StatefulWidget {
  const PolylineBody();

  @override
  State<StatefulWidget> createState() => PolylineBodyState();
}

class PolylineBodyState extends State<PolylineBody> {
  PolylineBodyState();

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  VietmapController? controller;
  int _polylineCount = 0;
  Line? _selectedPolyline;
  final String _polylinePatternImage = "assets/fill/cat_silhouette_pattern.png";

  void _onMapCreated(VietmapController controller) {
    this.controller = controller;
    controller.onPolylineTapped.add(_onPolylineTapped);
  }

  @override
  void dispose() {
    controller?.onPolylineTapped.remove(_onPolylineTapped);
    super.dispose();
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  _onPolylineTapped(Line line) async {
    await _updateSelectedPolyline(
      PolylineOptions(polylineColor: Colors.red),
    );
    setState(() {
      _selectedPolyline = line;
    });
    await _updateSelectedPolyline(
      PolylineOptions(polylineColor: Colors.red),
    );
  }

  _updateSelectedPolyline(PolylineOptions changes) async {
    if (_selectedPolyline != null)
      controller!.updatePolyline(_selectedPolyline!, changes);
  }

  void _addPolyline() {
    controller!.addPolyline(
      PolylineOptions(
          geometry: [
            LatLng(18.7037164, 105.655785),
            LatLng(18.794076, 105.578259),
            LatLng(18.926043, 105.565797),
            LatLng(19.071928, 105.623953),
          ],
          polylineColor: Colors.red,
          polylineWidth: 14.0,
          polylineOpacity: 0.5,
          draggable: true),
    );

    setState(() {
      _polylineCount += 1;
    });
  }

  _move() async {
    final currentStart = _selectedPolyline!.options.geometry![0];
    final currentEnd = _selectedPolyline!.options.geometry![1];
    final end =
        LatLng(currentEnd.latitude + 0.001, currentEnd.longitude + 0.001);
    final start =
        LatLng(currentStart.latitude - 0.001, currentStart.longitude - 0.001);
    await controller!.updatePolyline(
        _selectedPolyline!, PolylineOptions(geometry: [start, end]));
  }

  void _remove() {
    controller!.removePolyline(_selectedPolyline!);
    setState(() {
      _selectedPolyline = null;
      _polylineCount -= 1;
    });
  }

  Future<void> _changePolylinePattern() async {
    String? current = _selectedPolyline!.options.polylinePattern == null
        ? "assetImage"
        : null;
    await _updateSelectedPolyline(
      PolylineOptions(polylinePattern: current),
    );
  }

  Future<void> _changeAlpha() async {
    double? current = _selectedPolyline!.options.polylineOpacity;
    if (current == null) {
      // default value
      current = 1.0;
    }

    await _updateSelectedPolyline(
      PolylineOptions(polylineOpacity: current < 0.1 ? 1.0 : current * 0.75),
    );
  }

  Future<void> _toggleVisible() async {
    double? current = _selectedPolyline!.options.polylineOpacity;
    if (current == null) {
      // default value
      current = 1.0;
    }
    await _updateSelectedPolyline(
      PolylineOptions(polylineOpacity: current == 0.0 ? 1.0 : 0.0),
    );
  }

  _onStyleLoadedCallback() async {
    addImageFromAsset("assetImage", _polylinePatternImage);
    await controller!.addPolyline(
      PolylineOptions(
        geometry: [LatLng(37.4220, -122.0841), LatLng(37.4240, -122.0941)],
        polylineColor: Colors.red,
        polylineWidth: 14.0,
        polylineOpacity: 0.5,
      ),
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
            height: 400.0,
            child: VietmapGL(
              styleString: YOUR_STYLE_URL_HERE,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              initialCameraPosition: const CameraPosition(
                target: LatLng(18.7037164, 105.655785),
                zoom: 6.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        TextButton(
                          child: const Text('add'),
                          onPressed:
                              (_polylineCount == 12) ? null : _addPolyline,
                        ),
                        TextButton(
                          child: const Text('remove'),
                          onPressed:
                              (_selectedPolyline == null) ? null : _remove,
                        ),
                        TextButton(
                          child: const Text('move'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : () async {
                                  await _move();
                                },
                        ),
                        TextButton(
                          child: const Text('change line-pattern'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : _changePolylinePattern,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        TextButton(
                          child: const Text('change alpha'),
                          onPressed:
                              (_selectedPolyline == null) ? null : _changeAlpha,
                        ),
                        TextButton(
                          child: const Text('toggle visible'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : _toggleVisible,
                        ),
                        TextButton(
                          child: const Text('print current LatLng'),
                          onPressed: (_selectedPolyline == null)
                              ? null
                              : () async {
                                  var latLngs = await controller!
                                      .getLineLatLngs(_selectedPolyline!);
                                  for (var latLng in latLngs) {
                                    print(latLng.toString());
                                  }
                                },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
