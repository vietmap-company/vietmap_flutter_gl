part of vietmap_gl_platform_interface;

/// Support snapping user location to route,
/// tracking user's distance to route, etc.
class VietMapSnapEngine {
  /// Find the nearest point on the route to the user's location
  /// [route] the route to snap to
  /// [point] the user's location
  /// [unit] the unit of distance, default is kilometers. The unit will applied
  /// to the distance field in the result.
  static NearestLatLngResult? snapToRoute(List<LatLng> route, LatLng point,
      [Unit unit = Unit.kilometers]) {
    return VietmapPolyline.nearestLatLngOnLine(route, point, unit);
  }

  /// Calculate the distance of the route
  static double calculateRouteDistance(List<LatLng> route) {
    double distance = 0.0;
    for (int i = 0; i < route.length - 1; i++) {
      distance +=
          VietmapSphericalUtil.computeDistanceBetween(route[i], route[i + 1]);
    }
    return distance;
  }

  /// Check if the user is off route
  /// [route] the route to snap to
  /// [point] the user's location
  /// [unit] the unit of distance, default is meters. This unit will be applied
  /// for both of the result distance and limitDistance fields
  /// [limitDistance] the limit distance to consider the user is off route, default is 30 meters
  static bool isUserOffRoute(List<LatLng> route, LatLng point,
      {Unit unit = Unit.meters, double limitDistance = 30}) {
    final NearestLatLngResult? nearest = snapToRoute(route, point, unit);
    if (nearest == null) {
      return true;
    }
    return nearest.distance > limitDistance;
  }

  /// Calculate the distance from the user's location to the end of the route.
  /// Response measure in meters
  static double distanceToEndOfRoute(List<LatLng> route, LatLng point) {
    final NearestLatLngResult? nearest = snapToRoute(route, point);
    if (nearest == null) {
      return 0;
    }
    double distance = 0.0;
    distance =
        calculateRouteDistance([point, ...route.sublist(nearest.index + 1)]);
    return distance;
  }

  /// Calculate the distance from the user's location to the start of the route
  /// Response measure in meters
  static double distanceToStartOfRoute(List<LatLng> route, LatLng point) {
    final NearestLatLngResult? nearest = snapToRoute(route, point);
    if (nearest == null) {
      return 0;
    }
    double distance = 0.0;
    distance =
        calculateRouteDistance([point, ...route.sublist(0, nearest.index)]);
    return distance;
  }

  /// Get the remaining route from the user's location
  /// [route] the original route
  /// [point] the user's location
  /// Return the remaining route from the user's location
  static List<LatLng> getRouteRemaining(List<LatLng> route, LatLng point) {
    final NearestLatLngResult? nearest = snapToRoute(route, point);
    if (nearest == null) {
      return route;
    }
    return [point, ...route.sublist(nearest.index + 1)];
  }

  /// Get the traveled route from the user's location
  /// [route] the original route
  /// [point] the user's location
  /// Return the traveled route from the user's location
  static List<LatLng> getRouteTraveled(List<LatLng> route, LatLng point) {
    final NearestLatLngResult? nearest = snapToRoute(route, point);
    if (nearest == null) {
      return [];
    }
    return [...route.sublist(0, nearest.index), point];
  }
}
