part of vietmap_gl_platform_interface;

enum Unit {
  meters,
  millimeters,
  centimeters,
  kilometers,
  acres,
  miles,
  nauticalmiles,
  inches,
  yards,
  feet,
  radians,
  degrees,
}

const earthRadius = 6371008.8;

const factors = <Unit, num>{
  Unit.centimeters: earthRadius * 100,
  Unit.degrees: earthRadius / 111325,
  Unit.feet: earthRadius * 3.28084,
  Unit.inches: earthRadius * 39.370,
  Unit.kilometers: earthRadius / 1000,
  Unit.meters: earthRadius,
  Unit.miles: earthRadius / 1609.344,
  Unit.millimeters: earthRadius * 1000,
  Unit.nauticalmiles: earthRadius / 1852,
  Unit.radians: 1,
  Unit.yards: earthRadius / 1.0936,
};

class NearestLatLngResult {
  final LatLng point;
  final num distance;
  final int index;
  final num location;

  NearestLatLngResult({
    required this.point,
    required this.distance,
    required this.index,
    required this.location,
  });
  toJson() {
    return {
      'point': point.toJson(),
      'distance': distance,
      'index': index,
      'location': location,
    };
  }
}

class VietmapPolyline {
  static NearestLatLngResult? _nearestLatLngOnLine(
    List<LatLng> line,
    LatLng point, [
    Unit unit = Unit.kilometers,
    bool isGetStop = false,
  ]) {
    NearestLatLngResult? nearest;

    num length = 0;
    NearestLatLngResult? stopP;
    for (var i = 0; i < line.length - 1; ++i) {
      final startCoordinates = line[i];
      final stopCoordinates = line[i + 1];

      final startLatLng = startCoordinates;
      final stopLatLng = stopCoordinates;

      final sectionLength = distance(startLatLng, stopLatLng, unit);

      final start = NearestLatLngResult(
        point: startLatLng,
        distance: distance(point, startLatLng, unit),
        index: i,
        location: length,
      );

      final stop = NearestLatLngResult(
        point: stopLatLng,
        distance: distance(point, stopLatLng, unit),
        index: i + 1,
        location: length + sectionLength,
      );

      final heightDistance = max(start.distance, stop.distance);
      final direction = _bearing(startLatLng, stopLatLng);

      final perpendicular1 = _destination(
        point,
        heightDistance,
        direction + 90,
        unit,
      );

      final perpendicular2 = _destination(
        point,
        heightDistance,
        direction - 90,
        unit,
      );

      final intersectionLatLng = _intersects(
        [perpendicular1, perpendicular2],
        [startLatLng, stopLatLng],
      );

      NearestLatLngResult? intersection;

      if (intersectionLatLng != null) {
        intersection = NearestLatLngResult(
          point: intersectionLatLng,
          distance: distance(point, intersectionLatLng, unit),
          index: i,
          location: length + distance(startLatLng, intersectionLatLng, unit),
        );
      }

      if (nearest == null || start.distance < nearest.distance) {
        nearest = start;
      }

      if (stop.distance < nearest.distance) {
        nearest = stop;
        stopP = stop;
      }

      if (intersection != null && intersection.distance < nearest.distance) {
        nearest = intersection;
      }

      length += sectionLength;
    }

    /// A `List<LatLng>` is guaranteed to have at least two points and thus a
    /// nearest point has to exist.

    return isGetStop ? stopP : nearest;
  }

  static NearestLatLngResult? nearestLatLngOnLine(
    List<LatLng> line,
    LatLng point, [
    Unit unit = Unit.kilometers,
  ]) {
    return _nearestLatLngOnLine(line, point, unit);
  }

  static List<List<LatLng>> splitRouteByLatLng(
    List<LatLng> line,
    LatLng point, {
    Unit unit = Unit.kilometers,
    bool snapInputLatLngToResult = true,
  }) {
    var res = _nearestLatLngOnLine(line, point, unit, true);
    var line1 = line.sublist(0, res?.index ?? -1 + 1);
    if (snapInputLatLngToResult) {
      line1.add(point);
    }
    var line2 = line.sublist(res?.index ?? -1 + 1, line.length);
    if (snapInputLatLngToResult) {
      line2.insert(0, point);
    }
    return [line1, line2];
  }

  static num distance(LatLng from, LatLng to, [Unit unit = Unit.kilometers]) =>
      distanceRaw(from, to, unit);

  static num distanceRaw(LatLng from, LatLng to,
      [Unit unit = Unit.kilometers]) {
    var dLat = _degreesToRadians((to.latitude - from.latitude));
    var dLon = _degreesToRadians((to.longitude - from.longitude));
    var lat1 = _degreesToRadians(from.latitude);
    var lat2 = _degreesToRadians(to.latitude);

    num a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);

    return _radiansToLength(2 * atan2(sqrt(a), sqrt(1 - a)), unit);
  }

  static num _degreesToRadians(num degrees) {
    num radians = degrees.remainder(360);
    return radians * pi / 180;
  }

  static num _radiansToLength(num radians, [Unit unit = Unit.kilometers]) {
    var factor = factors[unit];
    if (factor == null) {
      throw Exception("$unit units is invalid");
    }
    return radians * factor;
  }

  static num _bearingRaw(LatLng start, LatLng end, {bool calcFinal = false}) {
    // Reverse calculation
    if (calcFinal == true) {
      return _calculateFinalBearingRaw(start, end);
    }

    num lng1 = _degreesToRadians(start.longitude);
    num lng2 = _degreesToRadians(end.longitude);
    num lat1 = _degreesToRadians(start.latitude);
    num lat2 = _degreesToRadians(end.latitude);
    num a = sin(lng2 - lng1) * cos(lat2);
    num b = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lng2 - lng1);

    return _radiansToDegrees(atan2(a, b));
  }

  static calculateFinalBearing(LatLng start, LatLng end) {
    return _bearing(start, end);
  }

  static num _bearing(LatLng start, LatLng end, {bool calcFinal = false}) =>
      _bearingRaw(start, end, calcFinal: calcFinal);

  static num _calculateFinalBearingRaw(LatLng start, LatLng end) {
    // Swap start & end
    num reverseBearing = _bearingRaw(end, start) + 180;
    return reverseBearing.remainder(360);
  }

  /// Calculates Final Bearing
  // static num _calculateFinalBearing(LatLng start, LatLng end) =>
  //     _calculateFinalBearingRaw(start, end);

  static num _radiansToDegrees(num radians) {
    num degrees = radians.remainder(2 * pi);
    return degrees * 180 / pi;
  }

  static LatLng _destinationRaw(LatLng origin, num distance, num bearing,
      [Unit unit = Unit.kilometers]) {
    num longitude1 = _degreesToRadians(origin.longitude);
    num latitude1 = _degreesToRadians(origin.latitude);
    num bearingRad = _degreesToRadians(bearing);
    num radians = _lengthToRadians(distance, unit);

    // Main
    num latitude2 = asin(sin(latitude1) * cos(radians) +
        cos(latitude1) * sin(radians) * cos(bearingRad));
    num longitude2 = longitude1 +
        atan2(sin(bearingRad) * sin(radians) * cos(latitude1),
            cos(radians) - sin(latitude1) * sin(latitude2));
    return LatLng(
      _radiansToDegrees(latitude2).toDouble(),
      _radiansToDegrees(longitude2).toDouble(),
    );
  }

  static LatLng _destination(LatLng origin, num distance, num bearing,
          [Unit unit = Unit.kilometers]) =>
      _destinationRaw(origin, distance, bearing, unit);

  static num _lengthToRadians(num distance, [Unit unit = Unit.kilometers]) {
    num? factor = factors[unit];
    if (factor == null) {
      throw Exception("$unit units is invalid");
    }
    return distance / factor;
  }

  static LatLng? _intersects(List<LatLng> line1, List<LatLng> line2) {
    if (line1.length != 2) {
      throw Exception('line1 must only contain 2 coordinates');
    }

    if (line2.length != 2) {
      throw Exception('line2 must only contain 2 coordinates');
    }

    final x1 = line1.first.longitude;
    final y1 = line1.first.latitude;
    final x2 = line1.last.longitude;
    final y2 = line1.last.latitude;
    final x3 = line2.first.longitude;
    final y3 = line2.first.latitude;
    final x4 = line2.last.longitude;
    final y4 = line2.last.latitude;

    final denom = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);

    if (denom == 0) {
      return null;
    }

    final numeA = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3);
    final numeB = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3);

    final uA = numeA / denom;
    final uB = numeB / denom;

    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
      final x = x1 + uA * (x2 - x1);
      final y = y1 + uA * (y2 - y1);

      return LatLng(y, x);
    }

    return null;
  }
}
