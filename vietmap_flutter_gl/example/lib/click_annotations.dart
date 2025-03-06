// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'page.dart';
import 'util.dart';

class ClickAnnotationPage extends ExamplePage {
  const ClickAnnotationPage({super.key})
      : super(const Icon(Icons.check_circle), 'Annotation tap');

  @override
  Widget build(BuildContext context) {
    return const ClickAnnotationBody();
  }
}

class ClickAnnotationBody extends StatefulWidget {
  const ClickAnnotationBody({super.key});

  @override
  State<StatefulWidget> createState() => ClickAnnotationBodyState();
}

class ClickAnnotationBodyState extends State<ClickAnnotationBody> {
  ClickAnnotationBodyState();

  static const LatLng center = LatLng(-33.88, 151.16);

  VietmapController? controller;

  void _onMapCreated(VietmapController controller) {
    this.controller = controller;
    controller.onPolygonTapped.add(_onFillTapped);
    controller.onCircleTapped.add(_onCircleTapped);
    controller.onPolylineTapped.add(_onLineTapped);
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  @override
  void dispose() {
    controller?.onPolygonTapped.remove(_onFillTapped);
    controller?.onCircleTapped.remove(_onCircleTapped);
    controller?.onPolylineTapped.remove(_onLineTapped);
    controller?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  _showSnackBar(String type, String id) {
    final snackBar = SnackBar(
        content: Text(
          'Tapped $type $id',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onFillTapped(Polygon fill) {
    _showSnackBar('fill', fill.id);
  }

  void _onCircleTapped(Circle circle) {
    _showSnackBar('circle', circle.id);
  }

  void _onLineTapped(Line line) {
    _showSnackBar('line', line.id);
  }

  void _onSymbolTapped(Symbol symbol) {
    _showSnackBar('symbol', symbol.id);
  }

  Future<void> _onStyleLoaded() async {
    await addImageFromAsset(
        controller!, "custom-marker", "assets/symbols/custom-marker.png");
    controller!.addCircle(
      const CircleOptions(
        geometry: LatLng(-33.881979408447314, 151.171361438502117),
        circleStrokeColor: Color(0xFF00FF00),
        circleStrokeWidth: 2,
        circleRadius: 16,
      ),
    );
    controller!.addCircle(
      const CircleOptions(
        geometry: LatLng(-33.894372606072309, 151.17576679759523),
        circleStrokeColor: Color(0xFF00FF00),
        circleStrokeWidth: 2,
        circleRadius: 30,
      ),
    );
    controller!.addSymbol(
      const SymbolOptions(
          geometry: LatLng(-33.894372606072309, 151.17576679759523),
          iconImage: "custom-marker", //"fast-food-15",
          iconSize: 2),
    );
    controller!.addPolyline(
      const PolylineOptions(
        geometry: [
          LatLng(-33.874867744475786, 151.170627211986584),
          LatLng(-33.881979408447314, 151.171361438502117),
          LatLng(-33.887058805548882, 151.175032571079726),
          LatLng(-33.894372606072309, 151.17576679759523),
          LatLng(-33.900060683994681, 151.15765587687909),
        ],
        polylineColor: Color(0xFF0000FF),
        polylineWidth: 20,
      ),
    );

    controller!.addPolygon(
      const PolygonOptions(
        geometry: [
          [
            LatLng(-33.901517742631846, 151.178099204457737),
            LatLng(-33.872845324482071, 151.179025547977773),
            LatLng(-33.868230472039514, 151.147000529140399),
            LatLng(-33.883172899638311, 151.150838238009328),
            LatLng(-33.894158309528244, 151.14223647675135),
            LatLng(-33.904812805307806, 151.155999294764086),
            LatLng(-33.901517742631846, 151.178099204457737),
          ],
        ],
        polygonColor: Color(0xFFFF0000),
        polygonOutlineColor: Color(0xFF000000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VietmapGL(
      annotationOrder: const [
        AnnotationType.polygon,
        AnnotationType.line,
        AnnotationType.circle,
        AnnotationType.symbol,
      ],
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoaded,
      initialCameraPosition: const CameraPosition(
        target: center,
        zoom: 12.0,
      ),
    );
  }
}
