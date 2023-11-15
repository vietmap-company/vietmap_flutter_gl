// This file is generated.

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of vietmap_gl_platform_interface;

class Line implements Annotation {
  Line(this._id, this.options, [this._data]);

  /// A unique identifier for this line.
  ///
  /// The identifier is an arbitrary unique string.
  final String _id;

  String get id => _id;

  final Map? _data;

  Map? get data => _data;

  /// The line configuration options most recently applied programmatically
  /// via the map controller.
  ///
  /// The returned value does not reflect any changes made to the line through
  /// touch events. Add listeners to the owning map controller to track those.
  PolylineOptions options;

  Map<String, dynamic> toGeoJson() {
    final geojson = options.toGeoJson();
    geojson["id"] = id;
    geojson["properties"]["id"] = id;

    return geojson;
  }

  @override
  void translate(LatLng delta) {
    options = options.copyWith(PolylineOptions(
        geometry: this.options.geometry?.map((e) => e + delta).toList()));
  }
}

/// Configuration options for [Line] instances.
///
/// When used to change configuration, null values will be interpreted as
/// "do not change this configuration option".
class PolylineOptions {
  /// Creates a set of line configuration options.
  ///
  /// By default, every non-specified field is null, meaning no desire to change
  /// line defaults or current configuration.
  const PolylineOptions({
    this.polylineJoin,
    this.polylineOpacity,
    this.polylineColor,
    this.polylineWidth,
    this.polylineGapWidth,
    this.polylineOffset,
    this.polylineBlur,
    this.polylinePattern,
    this.geometry,
    this.draggable,
  });

  final String? polylineJoin;
  final double? polylineOpacity;
  final Color? polylineColor;
  final double? polylineWidth;
  final double? polylineGapWidth;
  final double? polylineOffset;
  final double? polylineBlur;
  final String? polylinePattern;
  final List<LatLng>? geometry;
  final bool? draggable;

  static const PolylineOptions defaultOptions = PolylineOptions();

  PolylineOptions copyWith(PolylineOptions changes) {
    return PolylineOptions(
      polylineJoin: changes.polylineJoin ?? polylineJoin,
      polylineOpacity: changes.polylineOpacity ?? polylineOpacity,
      polylineColor: changes.polylineColor ?? polylineColor,
      polylineWidth: changes.polylineWidth ?? polylineWidth,
      polylineGapWidth: changes.polylineGapWidth ?? polylineGapWidth,
      polylineOffset: changes.polylineOffset ?? polylineOffset,
      polylineBlur: changes.polylineBlur ?? polylineBlur,
      polylinePattern: changes.polylinePattern ?? polylinePattern,
      geometry: changes.geometry ?? geometry,
      draggable: changes.draggable ?? draggable,
    );
  }

  dynamic toJson([bool addGeometry = true]) {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('lineJoin', polylineJoin);
    addIfPresent('lineOpacity', polylineOpacity);
    addIfPresent('lineColor', polylineColor.toHex());
    addIfPresent('lineWidth', polylineWidth);
    addIfPresent('lineGapWidth', polylineGapWidth);
    addIfPresent('lineOffset', polylineOffset);
    addIfPresent('lineBlur', polylineBlur);
    addIfPresent('linePattern', polylinePattern);
    if (addGeometry) {
      addIfPresent('geometry',
          geometry?.map((LatLng latLng) => latLng.toJson()).toList());
    }
    addIfPresent('draggable', draggable);
    return json;
  }

  Map<String, dynamic> toGeoJson() {
    return {
      "type": "Feature",
      "properties": toJson(false),
      "geometry": {
        "type": "LineString",
        "coordinates": geometry!.map((c) => c.toGeoJsonCoordinates()).toList()
      }
    };
  }
}
