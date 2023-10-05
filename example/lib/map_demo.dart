import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:maplibre_gl_example/given_bounds.dart';

import 'animate_camera.dart';
import 'annotation_order_maps.dart';
import 'full_map.dart';
import 'line.dart';

import 'map_ui.dart';
import 'move_camera.dart';
import 'click_annotations.dart';
import 'page.dart';
import 'place_circle.dart';

import 'place_polygon.dart';
import 'scrolling_map.dart';

import 'custom_marker.dart';
import 'place_batch.dart';
import 'layer.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';

final List<ExamplePage> _allPages = <ExamplePage>[
  MapUiPage(),
  FullMapPage(),
  AnimateCameraPage(),
  MoveCameraPage(),
  // PlaceSymbolPage(),
  // PlaceSourcePage(),
  PolylinePage(),
  // LocalStylePage(),
  LayerPage(),
  PlaceCirclePage(),
  PlacePolygonPage(),
  ScrollingMapPage(),
  // OfflineRegionsPage(),
  AnnotationOrderPage(),
  CustomMarkerPage(),
  BatchAddPage(),
  ClickAnnotationPage(),
  // Sources(),
  GivenBoundsPage(),
  // GetMapInfoPage(),
];

class MapsDemo extends StatefulWidget {
  @override
  State<MapsDemo> createState() => _MapsDemoState();
}

class _MapsDemoState extends State<MapsDemo> {
  @override
  void initState() {
    super.initState();
  }

  /// Determine the android version of the phone and turn off HybridComposition
  /// on older sdk versions to improve performance for these
  ///
  /// !!! Hybrid composition is currently broken do no use !!!
  Future<void> initHybridComposition() async {
    if (!kIsWeb && Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkVersion = androidInfo.version.sdkInt;
      if (sdkVersion != null && sdkVersion >= 29) {
        VietmapGL.useHybridComposition = true;
      } else {
        VietmapGL.useHybridComposition = false;
      }
    }
  }

  void _pushPage(BuildContext context, ExamplePage page) async {
    if (!kIsWeb) {
      final location = Location();
      final hasPermissions = await location.hasPermission();
      if (hasPermissions != PermissionStatus.granted) {
        await location.requestPermission();
      }
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VietmapGL examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}
