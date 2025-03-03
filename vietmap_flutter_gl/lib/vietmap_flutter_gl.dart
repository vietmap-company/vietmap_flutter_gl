// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// This library contains the VietMapGL plugin for Flutter.
///
/// To display a map, add a [VietmapGL] widget to the widget tree.
///
/// In this plugin, the map is configured through the parameters passed to the [VietmapGL] constructor and through the [VietmapController].
/// The [VietmapController] is provided at runtime by the [VietmapGL.onMapCreated] callback.
/// The controller also allows adding annotations (icons, lines etc.) to the map at runtime and provides some callbacks to get notified when the user clicks those.
///
/// The visual appearance of the map is configured through a MapLibre style passed to the
/// [styleString] parameter of the [VietmapGL] constructor.
/// The MapLibre style is a JSON document following the specification at https://maplibre.org/maplibre-style-spec/.
/// The following is supposed to serve as a short introduction to the MapLibre style specification:
/// The style document contains (among other things) sources and layers.
/// Sources determine which data is displayed on the map, layers determine how the data is displayed.
///
/// Typical types of sources are raster and vector tiles, as well as GeoJson data.
/// For raster and vector tiles, the entire world is divided into a set of tiles in different zoom levels.
/// Depending on the map's zoom level and viewport, the MapLibre client libraries decide, which tiles are needed to fill the viewport and request them from the source.
///
/// The difference between raster and vector tiles is that raster tiles are images that are pre-rendered on a server, whereas vector tiles contain raw geometric information that is rendered on the client.
/// Vector tiles are in the Mapbox Vector Tile (MVT) format, the de-facto standard for vector tiles that is implemented by multiple libraries.
///
/// Vector tiles have a number of advantages over raster tiles, including (often) smaller size,
/// the possibility to style them dynamically at runtime (e.g. change the color or visibility of certain features),
/// and the possibility to rotate them and keep text labels horizontal.
/// Raster and vector tiles can be generated from a variety of sources, including OpenStreetMap data and are also available from a number of providers.
///
/// Raster sources are displayed by adding a "raster" layer to the VietMapGL style.
/// Vector and GeoJson sources are displayed by adding a "line", "fill", "symbol" or "circle" layer to the VietMapGL style and specifying
/// which source to use (by setting the "source" property of the layer to the id of the source) as well as how to style the data by setting other properties of the layer such as "line-color" or "fill-outline-color".
/// For example, a vector source layer (or a GeoJson source layer) with the outlines of countries could be displayed both by a fill layer to fill the countries with a color and by a line layer to draw the outlines of the countries.
library maplibre_gl;

import 'dart:async';
import 'dart:convert';
import 'dart:math' hide log;

import 'dart:io';
import 'package:supercluster/supercluster.dart';
// import 'package:geolocator/geolocator.dart';

import 'package:turf/turf.dart' as turf;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vietmap_gl_platform_interface/vietmap_gl_platform_interface.dart';

import 'src/components/center_pulse.dart';

export 'package:vietmap_gl_platform_interface/vietmap_gl_platform_interface.dart'
    show
        Annotation,
        ArgumentCallbacks,
        AttributionButtonPosition,
        CameraPosition,
        CameraTargetBounds,
        CameraUpdate,
        Circle,
        CircleOptions,
        CompassViewPosition,
        Polygon,
        PolygonOptions,
        GeojsonSourceProperties,
        ImageSourceProperties,
        LatLng,
        LatLngBounds,
        LatLngQuad,
        Line,
        PolylineOptions,
        LocationEngineAndroidProperties,
        LocationEnginePlatforms,
        LocationPriority,
        MethodChannelVietmapGl,
        MinMaxZoomPreference,
        MyLocationRenderMode,
        MyLocationTrackingMode,
        OnPlatformViewCreatedCallback,
        RasterDemSourceProperties,
        RasterSourceProperties,
        SourceProperties,
        Symbol,
        SymbolOptions,
        UserHeading,
        UserLocation,
        VectorSourceProperties,
        VideoSourceProperties,
        VietmapGlPlatform;

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

part 'src/vietmap_styles.dart';

part 'src/marker.dart';

part 'src/marker_layer.dart';

part 'src/marker_model.dart';

part 'src/static_marker_model.dart';

part 'src/cluster_layer.dart';
part 'src/user_location_layer.dart';

part 'src/static_marker_layer.dart';

part 'src/animated_polyline.dart';
