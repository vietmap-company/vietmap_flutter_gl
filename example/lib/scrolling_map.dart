// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // ignore: unnecessary_import
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:maplibre_gl_example/util.dart';

import 'constant.dart';
import 'page.dart';

class ScrollingMapPage extends ExamplePage {
  ScrollingMapPage() : super(const Icon(Icons.map), 'Scrolling map');

  @override
  Widget build(BuildContext context) {
    return ScrollingMapBody();
  }
}

class ScrollingMapBody extends StatefulWidget {
  ScrollingMapBody();

  @override
  _ScrollingMapBodyState createState() => _ScrollingMapBodyState();
}

class _ScrollingMapBodyState extends State<ScrollingMapBody> {
  late VietmapController controllerOne;
  late VietmapController controllerTwo;

  final LatLng center = const LatLng(32.080664, 34.9563837);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text('This map consumes all touch events.'),
                ),
                Center(
                  child: SizedBox(
                    width: 300.0,
                    height: 300.0,
                    child: VietmapGL(
                      styleString: YOUR_STYLE_URL_HERE,
                      onMapCreated: onMapCreatedOne,
                      onStyleLoadedCallback: () => onStyleLoaded(controllerOne),
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 11.0,
                      ),
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>[
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      ].toSet(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              children: <Widget>[
                const Text('This map doesn\'t consume the vertical drags.'),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child:
                      Text('It still gets other gestures (e.g scale or tap).'),
                ),
                Center(
                  child: SizedBox(
                    width: 300.0,
                    height: 300.0,
                    child: VietmapGL(
                      styleString: YOUR_STYLE_URL_HERE,
                      onMapCreated: onMapCreatedTwo,
                      onStyleLoadedCallback: () => onStyleLoaded(controllerTwo),
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 11.0,
                      ),
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>[
                        Factory<OneSequenceGestureRecognizer>(
                          () => ScaleGestureRecognizer(),
                        ),
                      ].toSet(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onMapCreatedOne(VietmapController controller) {
    this.controllerOne = controller;
  }

  void onMapCreatedTwo(VietmapController controller) {
    this.controllerTwo = controller;
  }

  void onStyleLoaded(VietmapController controller) async {
    await addImageFromAsset(
        controller, "custom-marker", "assets/symbols/custom-marker.png");
    controller.addSymbol(SymbolOptions(
        geometry: LatLng(
          center.latitude,
          center.longitude,
        ),
        iconImage: "custom-marker"));
    controller.addPolyline(
      PolylineOptions(
        geometry: [
          LatLng(-33.86711, 151.1947171),
          LatLng(-33.86711, 151.1947171),
          LatLng(-32.86711, 151.1947171),
          LatLng(-33.86711, 152.1947171),
        ],
        polylineColor: Colors.red,
        polylineWidth: 7.0,
        polylineOpacity: 0.5,
      ),
    );
  }
}
