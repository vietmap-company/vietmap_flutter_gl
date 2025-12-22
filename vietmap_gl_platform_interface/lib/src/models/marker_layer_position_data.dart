part of '../../vietmap_gl_platform_interface.dart';

class MarkerPositionData {
  // Original latitude of the marker
  final double latitude;

  // Original longitude of the marker
  final double longitude;

  // Position of the marker in the map, in pixels (x axis)
  final double? x;

  // Position of the marker in the map, in pixels (y axis)
  final double? y;

  // Identifier of the marker, used to update the position of the marker
  final String markerId;

  MarkerPositionData(
      {required this.latitude,
      required this.longitude,
      this.x,
      this.y,
      required this.markerId});

  factory MarkerPositionData.fromMap(Map<String, dynamic> map) {
    return MarkerPositionData(
        latitude: map['latitude'] ?? 0,
        longitude: map['longitude'] ?? 0,
        x: map['x'] ?? 0,
        y: map['y'] ?? 0,
        markerId: map['markerId'] ?? '');
  }

  Map toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'x': x,
      'y': y,
      'markerId': markerId
    };
  }
}

class MarkerLayerPositionData {
  // List of markers and their positions
  final List<MarkerPositionData> markers;

  // Identifier of the layer, used to update the position of the layer
  final String layerId;

  MarkerLayerPositionData({required this.markers, required this.layerId});

  factory MarkerLayerPositionData.fromMap(Map<String, dynamic> map) {
    return MarkerLayerPositionData(
        markers: List<MarkerPositionData>.from(
            map['markers']?.map((x) => MarkerPositionData.fromMap(x)) ?? []),
        layerId: map['layerId'] ?? '');
  }

  Map toJson() {
    return {
      'markers': markers.map((x) => x.toJson()).toList(),
      'layerId': layerId
    };
  }
}
