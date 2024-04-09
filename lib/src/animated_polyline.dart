part of vietmap_flutter_gl;

class PolylineAnimation {
  List<turf.Position> _coordinates = [];
  late turf.Feature<turf.LineString> _lineStringFeature;

  double _totalDistance = 0;

  PolylineAnimation(List<LatLng> listLatLng) {
    var lineStringFeature = makeLineString(listLatLng);
    _coordinates = lineStringFeature.geometry?.coordinates ?? [];
    _lineStringFeature = lineStringFeature;

    for (var i = 1; i < _coordinates.length; i++) {
      _totalDistance += turf.distance(get(i - 1), get(i));
    }
  }

  turf.Feature<turf.Point> coordinateFromStart(double distance) {
    var pointAlong = turf.along(_lineStringFeature, distance);
    pointAlong.properties = {
      'distance': distance,
      'nearestIndex': findNearestFloorIndex(distance)
    };
    pointAlong.properties?['distance'] = distance;
    pointAlong.properties?['nearestIndex'] = findNearestFloorIndex(distance);
    return pointAlong;
  }

  int findNearestFloorIndex(double currentDistance) {
    var runningDistance = 0.0;

    for (var i = 1; i < _coordinates.length; i++) {
      runningDistance += turf.distance(get(i - 1), get(i));

      if (runningDistance >= currentDistance) {
        return i - 1;
      }
    }
    return -1;
  }

  turf.Feature<turf.LineString> makeLineString(List<LatLng> latLng) {
    List<turf.Position> listPoint =
        latLng.map((e) => turf.Position(e.longitude, e.latitude)).toList();
    return turf.Feature<turf.LineString>(
        id: listPoint.hashCode.toString(),
        geometry: turf.LineString(coordinates: listPoint));
  }

  turf.Point get(index) {
    return turf.Point(
        coordinates:
            turf.Position(_coordinates[index].first, _coordinates[index].last));
  }

  get totalDistance {
    return _totalDistance;
  }
}

class RouteSimulator {
  late PolylineAnimation _polyline;
  double _currentDistance = 0;
  late double _speed;
  Function(LatLng?, int?, double?)? _listener;
  late AnimationController _animationController;
  Timer? timer;
  late Duration duration;

  /// vsync from `TickerProviderStateMixin` class, used to init
  /// AnimationController
  RouteSimulator(List<LatLng> listLatLng, TickerProvider vsync,
      {double speed = 0.001,
      bool repeat = false,
      Duration duration = const Duration(seconds: 10),
      double upperBound = 2.2,
      AnimationBehavior animationBehavior = AnimationBehavior.normal}) {
    _polyline = PolylineAnimation(listLatLng);
    _currentDistance = 0;
    _speed = speed;
    this.duration = duration;

    _animationController = AnimationController(
        upperBound: upperBound,
        vsync: vsync,
        duration: duration,
        animationBehavior: animationBehavior)
      ..forward()
      ..addListener(() {
        if (_animationController.isCompleted && repeat) {
          _animationController.repeat();
        }
      });
    ;
  }

  get getAnimationController => _animationController;

  /// this function return current `LatLng` and a value that present if the
  /// animation is completed (1 time).
  /// Function(LatLng? currentLatLng, int? nearestIndex, double? distance)
  void addListener(void Function(LatLng?, int?, double?)? listener) {
    _listener = listener;
  }

  void start() {
    tick();
  }

  void reset() {
    _currentDistance = 0;
    start();
  }

  void stop() {
    _animationController.stop();
  }

  void tick() {
    _animationController.forward();

    _animationController.addListener(() {
      _currentDistance += _speed;
      // interpolate between previous to current distance
      var currentPosition =
          _polyline.coordinateFromStart(_animationController.value);
      emit(currentPosition);
      if (_currentDistance > _polyline.totalDistance) {
        reset();
        return;
      }
    });
  }

  void emit(
    turf.Feature<turf.Point>? pointFeature,
  ) {
    if (_listener != null) {
      if (pointFeature?.geometry != null) {
        _listener!(
            LatLng(pointFeature!.geometry!.coordinates.lat.toDouble(),
                pointFeature.geometry!.coordinates.lng.toDouble()),
            pointFeature.properties?['nearestIndex'],
            pointFeature.properties?['distance']);
      }
    }
  }
}
