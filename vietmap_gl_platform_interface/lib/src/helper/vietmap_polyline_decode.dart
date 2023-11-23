part of vietmap_gl_platform_interface;

/// Decode the google encoded string using Encoded Polyline Algorithm Format
/// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm

class VietmapPolylineDecoder {
  static List<LatLng> decodePolyline(String encodedString) {
    return _run(encodedString);
  }

  static String encodePolyline(final List<LatLng> path) {
    var lastLat = 0;
    var lastLng = 0;

    final result = StringBuffer();

    for (final point in path) {
      final lat = (point.latitude * 1e5).round();
      final lng = (point.longitude * 1e5).round();

      _encode(lat - lastLat, result);
      _encode(lng - lastLng, result);

      lastLat = lat;
      lastLng = lng;
    }
    return result.toString();
  }

  static void _encode(int v, StringBuffer result) {
    v = v < 0 ? ~(v << 1) : v << 1;
    while (v >= 0x20) {
      result.write(String.fromCharCode((0x20 | (v & 0x1f)) + 63));
      v >>= 5;
    }
    result.write(String.fromCharCode(v + 63));
  }

  static List<LatLng> _run(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    BigInt big0 = BigInt.from(0);
    BigInt big0x1f = BigInt.from(0x1f);
    BigInt big0x20 = BigInt.from(0x20);

    while (index < len) {
      int shift = 0;
      BigInt b, result;
      result = big0;
      do {
        b = BigInt.from(encoded.codeUnitAt(index++) - 63);
        result |= (b & big0x1f) << shift;
        shift += 5;
      } while (b >= big0x20);
      BigInt rShifted = result >> 1;
      int dLat;
      if (result.isOdd) {
        dLat = (~rShifted).toInt();
      } else {
        dLat = rShifted.toInt();
      }
      lat += dLat;

      shift = 0;
      result = big0;
      do {
        b = BigInt.from(encoded.codeUnitAt(index++) - 63);
        result |= (b & big0x1f) << shift;
        shift += 5;
      } while (b >= big0x20);
      rShifted = result >> 1;
      int dLng;
      if (result.isOdd) {
        dLng = (~rShifted).toInt();
      } else {
        dLng = rShifted.toInt();
      }
      lng += dLng;

      points.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return points;
  }
}
