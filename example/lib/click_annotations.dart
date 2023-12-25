// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'constant.dart';
import 'page.dart';
import 'util.dart';

class ClickAnnotationPage extends ExamplePage {
  ClickAnnotationPage()
      : super(const Icon(Icons.check_circle), 'Annotation tap');

  @override
  Widget build(BuildContext context) {
    return const ClickAnnotationBody();
  }
}

class ClickAnnotationBody extends StatefulWidget {
  const ClickAnnotationBody();

  @override
  State<StatefulWidget> createState() => ClickAnnotationBodyState();
}

class ClickAnnotationBodyState extends State<ClickAnnotationBody> {
  ClickAnnotationBodyState();
  static const LatLng center = const LatLng(10.88, 106.16);

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
        content: Text('Tapped $type $id',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  void _onStyleLoaded() async {
    await addImageFromAsset(
        controller!, "custom-marker", "assets/symbols/custom-marker.png");
    controller!.addCircle(
      CircleOptions(
        geometry: LatLng(10.881979408447314, 106.171361438502117),
        circleStrokeColor: Color(0xFF00FF00),
        circleStrokeWidth: 2,
        circleRadius: 16,
      ),
    );
    controller!.addCircle(
      CircleOptions(
        geometry: LatLng(10.894372606072309, 106.17576679759523),
        circleStrokeColor: Color(0xFF00FF00),
        circleStrokeWidth: 2,
        circleRadius: 30,
      ),
    );
    controller!.addSymbol(
      SymbolOptions(
          geometry: LatLng(10.894372606072309, 106.17576679759523),
          iconImage: "custom-marker", //"fast-food-15",
          iconSize: 2),
    );
    controller!.addPolyline(
      PolylineOptions(
        geometry: [
          LatLng(10.874867744475786, 106.170627211986584),
          LatLng(10.881979408447314, 106.171361438502117),
          LatLng(10.887058805548882, 106.175032571079726),
          LatLng(10.894372606072309, 106.17576679759523),
          LatLng(10.900060683994681, 106.15765587687909),
        ],
        polylineColor: Colors.red,
        polylineWidth: 20,
      ),
    );

    controller!.addPolygon(
      PolygonOptions(
        geometry: [
          [
            LatLng(10.901067742631846, 106.178099204457737),
            LatLng(10.872845324482071, 106.179025547977773),
            LatLng(10.868230472039514, 106.147000529140399),
            LatLng(10.883172899638311, 106.150838238009328),
            LatLng(10.894158309528244, 106.14223647675135),
            LatLng(10.904812805307806, 106.155999294764086),
            LatLng(10.901067742631846, 106.178099204457737),
          ],
        ],
        polygonColor: Color(0xFFFF0000),
        polygonOutlineColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VietmapGL(
      styleString: YOUR_STYLE_URL_HERE,
      annotationOrder: [
        AnnotationType.polygon,
        AnnotationType.polyline,
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
