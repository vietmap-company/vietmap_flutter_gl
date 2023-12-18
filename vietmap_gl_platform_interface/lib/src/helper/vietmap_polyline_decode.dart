part of vietmap_gl_platform_interface;

/// Decode the google encoded string using Encoded Polyline Algorithm Format
/// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm

class VietmapPolylineDecoder {
  static List<LatLng> decodePolyline(String encodedString,
      [bool isPolyline6 = true]) {
    return _decodePolyline6(encodedString, isPolyline6 ? 1e6 : 1e5);
  }

  static String encodePolyline(final List<LatLng> path,
      [bool isPolyline6 = true]) {
    var lastLat = 0;
    var lastLng = 0;
    var mul = isPolyline6 ? 1e6 : 1e5;

    final result = StringBuffer();

    for (final point in path) {
      final lat = (point.latitude * mul).round();
      final lng = (point.longitude * mul).round();

      _encodeVMPL(lat - lastLat, result);
      _encodeVMPL(lng - lastLng, result);

      lastLat = lat;
      lastLng = lng;
    }

    return result.toString();
  }

  static void _encodeVMPL(int v, StringBuffer result) {
    v = v < 0 ? ~(v << 1) : v << 1;
    while (v >= 0x20) {
      result.write(String.fromCharCode((0x20 | (v & 0x1f)) + 63));
      v >>= 5;
    }
    result.write(String.fromCharCode(v + 63));
  }

  static List<LatLng> _decodePolyline6(String encoded, double mul) {
    // precision
    var inv = 1.0 / mul;
    var decoded = <LatLng>[];
    var previous = [0, 0];
    var i = 0;
    // for each byte
    while (i < encoded.length) {
      // for each coord (lat, lon)
      var latLng = [0, 0];
      for (var j = 0; j < 2; j++) {
        var shift = 0;
        var byte = 0x20;
        // keep decoding bytes until you have this coord
        while (byte >= 0x20) {
          byte = encoded.codeUnitAt(i++) - 63;
          latLng[j] |= (byte & 0x1f) << shift;
          shift += 5;
        }
        // add previous offset to get the final value and remember for the next one
        latLng[j] = previous[j] +
            (latLng[j] & 1 == 1 ? ~(latLng[j] >> 1) : (latLng[j] >> 1));
        previous[j] = latLng[j];
      }
      // scale by precision and chop off long coords also flip the positions so
      // it's the far more standard lon,lat instead of lat,lon

      var temp = LatLng(latLng[0] * inv, latLng[1] * inv);
      decoded.add(temp);
    }
    // hand back the list of coordinates
    return decoded;
  }
}
