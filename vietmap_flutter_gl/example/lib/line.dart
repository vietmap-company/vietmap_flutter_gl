// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'page.dart';

class LinePage extends ExamplePage {
  const LinePage({super.key}) : super(const Icon(Icons.share), 'Line');

  @override
  Widget build(BuildContext context) {
    return const LineBody();
  }
}

class LineBody extends StatefulWidget {
  const LineBody({super.key});

  @override
  State<StatefulWidget> createState() => LineBodyState();
}

class LineBodyState extends State<LineBody> {
  LineBodyState();

  static const LatLng center = LatLng(-33.86711, 151.1947171);

  VietmapController? controller;
  int _lineCount = 0;
  Line? _selectedLine;
  final String _linePatternImage = "assets/fill/cat_silhouette_pattern.png";

  void _onMapCreated(VietmapController controller) {
    this.controller = controller;
    controller.onPolylineTapped.add(_onLineTapped);
  }

  @override
  void dispose() {
    controller?.onPolylineTapped.remove(_onLineTapped);
    super.dispose();
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final bytes = await rootBundle.load(assetName);
    final list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  _onLineTapped(Line line) async {
    await _updateSelectedLine(
      const PolylineOptions(polylineColor: Color(0xFFff0000)),
    );
    setState(() {
      _selectedLine = line;
    });
    await _updateSelectedLine(
      const PolylineOptions(polylineColor: Color(0xFFffe100)),
    );
  }

  _updateSelectedLine(PolylineOptions changes) async {
    if (_selectedLine != null)
      controller!.updatePolyline(_selectedLine!, changes);
  }

  void _add() {
    controller!.addPolyline(
      const PolylineOptions(
          geometry: [
            LatLng(-33.86711, 151.1947171),
            LatLng(-33.86711, 151.1947171),
            LatLng(-32.86711, 151.1947171),
            LatLng(-33.86711, 152.1947171),
          ],
          polylineColor: Color(0xFFff0000),
          polylineWidth: 14.0,
          polylineOpacity: 0.5,
          draggable: true),
    );
    setState(() {
      _lineCount += 1;
    });
  }

  _move() async {
    final currentStart = _selectedLine!.options.geometry![0];
    final currentEnd = _selectedLine!.options.geometry![1];
    final end =
        LatLng(currentEnd.latitude + 0.001, currentEnd.longitude + 0.001);
    final start =
        LatLng(currentStart.latitude - 0.001, currentStart.longitude - 0.001);
    await controller!.updatePolyline(
        _selectedLine!, PolylineOptions(geometry: [start, end]));
  }

  void _remove() {
    controller!.removePolyline(_selectedLine!);
    setState(() {
      _selectedLine = null;
      _lineCount -= 1;
    });
  }

  Future<void> _changeLinePattern() async {
    final current =
        _selectedLine!.options.polylinePattern == null ? "assetImage" : null;
    await _updateSelectedLine(
      PolylineOptions(polylinePattern: current),
    );
  }

  Future<void> _changeAlpha() async {
    var current = _selectedLine!.options.polylineOpacity;
    current ??= 1.0;

    await _updateSelectedLine(
      PolylineOptions(polylineOpacity: current < 0.1 ? 1.0 : current * 0.75),
    );
  }

  Future<void> _toggleVisible() async {
    var current = _selectedLine!.options.polylineOpacity;
    current ??= 1.0;
    await _updateSelectedLine(
      PolylineOptions(polylineOpacity: current == 0.0 ? 1.0 : 0.0),
    );
  }

  _onStyleLoadedCallback() async {
    addImageFromAsset("assetImage", _linePatternImage);
    await controller!.addPolyline(
      const PolylineOptions(
        geometry: [LatLng(37.4220, -122.0841), LatLng(37.4240, -122.0941)],
        polylineColor: Color(0xFFff0000),
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
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-33.852, 151.211),
                zoom: 11.0,
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
                          onPressed: (_lineCount == 12) ? null : _add,
                          child: const Text('add'),
                        ),
                        TextButton(
                          onPressed: (_selectedLine == null) ? null : _remove,
                          child: const Text('remove'),
                        ),
                        TextButton(
                          onPressed: (_selectedLine == null)
                              ? null
                              : () async {
                                  await _move();
                                },
                          child: const Text('move'),
                        ),
                        TextButton(
                          onPressed: (_selectedLine == null)
                              ? null
                              : _changeLinePattern,
                          child: const Text('change line-pattern'),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        TextButton(
                          onPressed:
                              (_selectedLine == null) ? null : _changeAlpha,
                          child: const Text('change alpha'),
                        ),
                        TextButton(
                          onPressed:
                              (_selectedLine == null) ? null : _toggleVisible,
                          child: const Text('toggle visible'),
                        ),
                        TextButton(
                          onPressed: (_selectedLine == null)
                              ? null
                              : () async {
                                  final latLngs = await controller!
                                      .getLineLatLngs(_selectedLine!);
                                  for (final latLng in latLngs) {
                                    debugPrint(latLng.toString());
                                  }
                                },
                          child: const Text('print current LatLng'),
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
