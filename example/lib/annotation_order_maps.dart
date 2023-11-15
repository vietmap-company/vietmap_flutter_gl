import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // ignore: unnecessary_import
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'constant.dart';
import 'page.dart';
import 'util.dart';

class AnnotationOrderPage extends ExamplePage {
  AnnotationOrderPage()
      : super(const Icon(Icons.layers), 'Annotation order maps');

  @override
  Widget build(BuildContext context) => AnnotationOrderBody();
}

class AnnotationOrderBody extends StatefulWidget {
  AnnotationOrderBody();

  @override
  _AnnotationOrderBodyState createState() => _AnnotationOrderBodyState();
}

class _AnnotationOrderBodyState extends State<AnnotationOrderBody> {
  late VietmapController controllerOne;
  late VietmapController controllerTwo;

  final LatLng center = const LatLng(36.580664, 32.5563837);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                      'This map has polygones (fill) above all other anotations (default behavior)'),
                ),
                Center(
                  child: SizedBox(
                    width: 250.0,
                    height: 250.0,
                    child: VietmapGL(
                      onMapCreated: onMapCreatedOne,
                      onStyleLoadedCallback: () => onStyleLoaded(controllerOne),
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 5.0,
                      ),
                      annotationOrder: const [
                        AnnotationType.polyline,
                        AnnotationType.symbol,
                        AnnotationType.circle,
                        AnnotationType.polygon,
                      ],
                      styleString: YOUR_STYLE_URL_HERE,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                  child: Text(
                      'This map has polygones (fill) under all other anotations'),
                ),
                Center(
                  child: SizedBox(
                    width: 250.0,
                    height: 250.0,
                    child: VietmapGL(
                      styleString: YOUR_STYLE_URL_HERE,
                      onMapCreated: onMapCreatedTwo,
                      onStyleLoadedCallback: () => onStyleLoaded(controllerTwo),
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 5.0,
                      ),
                      annotationOrder: const [
                        AnnotationType.polygon,
                        AnnotationType.polyline,
                        AnnotationType.symbol,
                        AnnotationType.circle,
                      ],
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
    controller.addSymbol(
      SymbolOptions(
        geometry: LatLng(
          center.latitude,
          center.longitude,
        ),
        iconImage: "custom-marker", // "airport-15",
      ),
    );
    controller.addPolyline(
      PolylineOptions(
        draggable: false,
        polylineColor: Colors.red,
        polylineWidth: 7.0,
        polylineOpacity: 1,
        geometry: [
          LatLng(35.3649902, 32.0593003),
          LatLng(34.9475098, 31.1187944),
          LatLng(36.7108154, 30.7040582),
          LatLng(37.6995850, 33.6512083),
          LatLng(35.8648682, 33.6969227),
          LatLng(35.3814697, 32.0546447),
        ],
      ),
    );
    controller.addPolygon(
      PolygonOptions(
        draggable: false,
        polygonColor: Color(0xFF008888),
        polygonOpacity: 0.3,
        geometry: [
          [
            LatLng(35.3649902, 32.0593003),
            LatLng(34.9475098, 31.1187944),
            LatLng(36.7108154, 30.7040582),
            LatLng(37.6995850, 33.6512083),
            LatLng(35.8648682, 33.6969227),
            LatLng(35.3814697, 32.0546447),
          ]
        ],
      ),
    );
  }
}
