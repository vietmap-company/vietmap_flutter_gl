// This file is generated.

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../vietmap_gl_platform_interface.dart';

PolygonOptions translateFillOptions(PolygonOptions options, LatLng delta) {
  if (options.geometry != null) {
    final newGeometry = <List<LatLng>>[];
    for (final ring in options.geometry!) {
      final newRing = <LatLng>[];
      for (final coords in ring) {
        newRing.add(coords + delta);
      }
      newGeometry.add(newRing);
    }
    return options.copyWith(PolygonOptions(geometry: newGeometry));
  }
  return options;
}

class Polygon implements Annotation {
  Polygon(this._id, this.options, [this._data]);

  /// A unique identifier for this fill.
  ///
  /// The identifier is an arbitrary unique string.
  final String _id;
  @override
  String get id => _id;

  final Map? _data;
  Map? get data => _data;

  /// The fill configuration options most recently applied programmatically
  /// via the map controller.
  ///
  /// The returned value does not reflect any changes made to the fill through
  /// touch events. Add listeners to the owning map controller to track those.
  PolygonOptions options;

  @override
  Map<String, dynamic> toGeoJson() {
    final geojson = options.toGeoJson();
    geojson["id"] = id;
    geojson["properties"]["id"] = id;

    return geojson;
  }

  @override
  void translate(LatLng delta) {
    options = translateFillOptions(options, delta);
  }
}

/// Configuration options for [Polygon] instances.
///
/// When used to change configuration, null values will be interpreted as
/// "do not change this configuration option".
class PolygonOptions {
  /// Creates a set of fill configuration options.
  ///
  /// By default, every non-specified field is null, meaning no desire to change
  /// fill defaults or current configuration.
  const PolygonOptions(
      {this.fillOpacity,
      this.fillColor,
      this.fillOutlineColor,
      this.fillPattern,
      this.geometry,
      this.draggable});

  final double? fillOpacity;
  final String? fillColor;
  final String? fillOutlineColor;
  final String? fillPattern;
  final List<List<LatLng>>? geometry;
  final bool? draggable;

  static const PolygonOptions defaultOptions = PolygonOptions();

  PolygonOptions copyWith(PolygonOptions changes) {
    return PolygonOptions(
      fillOpacity: changes.fillOpacity ?? fillOpacity,
      fillColor: changes.fillColor ?? fillColor,
      fillOutlineColor: changes.fillOutlineColor ?? fillOutlineColor,
      fillPattern: changes.fillPattern ?? fillPattern,
      geometry: changes.geometry ?? geometry,
      draggable: changes.draggable ?? draggable,
    );
  }

  dynamic toJson([bool addGeometry = true]) {
    final json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('fillOpacity', fillOpacity);
    addIfPresent('fillColor', fillColor);
    addIfPresent('fillOutlineColor', fillOutlineColor);
    addIfPresent('fillPattern', fillPattern);
    if (addGeometry) {
      addIfPresent(
          'geometry',
          geometry
              ?.map((List<LatLng> latLngList) =>
                  latLngList.map((LatLng latLng) => latLng.toJson()).toList())
              .toList());
    }
    addIfPresent('draggable', draggable);
    return json;
  }

  Map<String, dynamic> toGeoJson() {
    return {
      "type": "Feature",
      "properties": toJson(false),
      "geometry": {
        "type": "Polygon",
        "coordinates": geometry!
            .map((List<LatLng> latLngList) => latLngList
                .map((LatLng latLng) => latLng.toGeoJsonCoordinates())
                .toList())
            .toList()
      }
    };
  }
}
