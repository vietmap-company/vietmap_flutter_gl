// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library vietmap_flutter_gl;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' hide log;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';

import 'package:turf/turf.dart' as turf;
import 'package:vietmap_flutter_gl/src/components/center_pulse.dart';
import 'package:vietmap_gl_platform_interface/vietmap_gl_platform_interface.dart';

export 'package:vietmap_gl_platform_interface/vietmap_gl_platform_interface.dart'
    show
        LatLng,
        LatLngBounds,
        LatLngQuad,
        CameraPosition,
        UserLocation,
        UserHeading,
        CameraUpdate,
        ArgumentCallbacks,
        Symbol,
        SymbolOptions,
        CameraTargetBounds,
        MinMaxZoomPreference,
        MyLocationTrackingMode,
        MyLocationRenderMode,
        CompassViewPosition,
        AttributionButtonPosition,
        Annotation,
        Circle,
        CircleOptions,
        Line,
        PolylineOptions,
        Polygon,
        PolygonOptions,
        SourceProperties,
        RasterSourceProperties,
        VectorSourceProperties,
        RasterDemSourceProperties,
        GeojsonSourceProperties,
        VideoSourceProperties,
        ImageSourceProperties;

part 'src/controller.dart';

part 'src/vietmap_gl.dart';

part 'src/global.dart';

part 'src/offline_region.dart';

part 'src/download_region_status.dart';

part 'src/layer_expressions.dart';

part 'src/layer_properties.dart';

part 'src/color_tools.dart';

part 'src/annotation_manager.dart';

part 'src/util.dart';

part 'src/marker.dart';

part 'src/marker_layer.dart';

part 'src/marker_model.dart';

part 'src/static_marker_model.dart';

part 'src/cluster_layer.dart';
part 'src/user_location_layer.dart';

part 'src/static_marker_layer.dart';

part 'src/animated_polyline.dart';
