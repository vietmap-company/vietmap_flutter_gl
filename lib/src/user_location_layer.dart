part of '../vietmap_flutter_gl.dart';

class UserLocationLayer extends StatefulWidget {
  /// The icon that will be used to represent the user's location on the map.
  final Widget? locationIcon;

  /// The icon that will be used to represent the user's bearing on the map.
  final Widget? bearingIcon;
  final Color pulseColor;
  final double pulseOpacity;

  /// The controller of the map.
  final VietmapController mapController;

  /// Set this value to true to ignore pointer events on the markers.
  /// If you using a marker like a button and have a [GestureDetector] inside it,
  /// set this value to false to prevent the map from receiving the gesture.
  final bool? ignorePointer;

  /// The size of the icon that will be used to represent the user's location on the map.
  /// This will apply for icon only, not for pulse size.
  final double iconSize;

  /// The markers to be placed on the map.
  /// use [UserLocationLayer] inside a [Stack], that contain [VietmapGL] and [UserLocationLayer] to work properly
  /// [VietmapGL.trackCameraPosition] must be set to true to work properly
  const UserLocationLayer(
      {Key? key,
      this.locationIcon,
      this.bearingIcon,
      required this.mapController,
      this.ignorePointer,
      this.pulseOpacity = 0.3,
      this.iconSize = 50,
      this.pulseColor = Colors.blue})
      : super(key: key);

  @override
  State<UserLocationLayer> createState() => _UserLocationLayerState();
}

class _UserLocationLayerState extends State<UserLocationLayer> {
  VietmapController get _mapController => widget.mapController;
  MarkerState? _positionMarkerStates;
  UserLocation? _currentPosition;
  Widget? _child;
  double _pulseSize = 0;
  LatLng? _location;
  Point<num>? _initialPosition;
  double get _iconSize => widget.iconSize;
  double lastBearing = 0;
  @override
  void didUpdateWidget(covariant UserLocationLayer oldWidget) {
    _updatePulseSize();

    if (_currentPosition == null) return;
    LatLng location = LatLng(_currentPosition?.position.latitude ?? 0,
        _currentPosition?.position.longitude ?? 0);
    _mapController.toScreenLocationBatch([location]).then((value) {
      if (mounted)
        setState(() {
          this._location = location;
          _initialPosition = value.first;
        });
    });
    super.didUpdateWidget(oldWidget);
  }

  Function()? onMapListener;
  Function(CameraPosition?)? onLocationMarkerListener;

  @override
  void initState() {
    _updatePulseSize();
    _updateUserLocationWidget();
    onMapListener = () {
      _updatePulseSize();
      _updateUserLocationPosition();
      _updateUserLocationWidget();
    };
    onLocationMarkerListener = (cameraPosition) {
      _updateUserLocationPosition();
    };
    // _mapController.getPlatform.onCameraIdlePlatform
    //     .add(onLocationMarkerListener!);
    _mapController.addListener(onMapListener!);
    _mapController.getPlatform.onUserLocationUpdatedPlatform.add((event) {
      _currentPosition = event;
      if (_currentPosition == null) return;
      LatLng location = LatLng(_currentPosition?.position.latitude ?? 0,
          _currentPosition?.position.longitude ?? 0);
      _mapController.toScreenLocationBatch([location]).then((value) {
        if (mounted)
          setState(() {
            this._location = location;
            _initialPosition = value.first;
          });
      });
      _updatePulseSize();
      _updateUserLocationPosition();
      _updateUserLocationWidget();
    });
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LatLng? currentLatLng = await _mapController.requestMyLocationLatLng();
      if (currentLatLng != null) {
        if (mounted)
          setState(() {
            _currentPosition = UserLocation(
                position: currentLatLng,
                latitude: currentLatLng.latitude,
                bearing: 0,
                speed: 0,
                horizontalAccuracy: 0,
                verticalAccuracy: 0,
                timestamp: DateTime.now(),
                heading: null);
          });
      }
    });
    // if (currentPosition == null) return;
    LatLng location =
        widget.mapController.cameraPosition?.target ?? LatLng(0, 0);
    _mapController.toScreenLocationBatch([location]).then((value) {
      if (mounted)
        setState(() {
          this._location = location;
          _initialPosition = value.first;
        });
    });
  }

  @override
  void dispose() {
    _mapController.getPlatform.onCameraIdlePlatform
        .remove(onLocationMarkerListener!);
    _mapController.removeListener(onMapListener!);
    super.dispose();
  }

  void _updateUserLocationPosition() {
    final coordinates = <LatLng>[];

    if (_positionMarkerStates != null)
      coordinates.add(_positionMarkerStates!.getCoordinate());

    _mapController.toScreenLocationBatch(coordinates).then((points) {
      if (points.isEmpty || _positionMarkerStates == null) return;
      _positionMarkerStates!.updatePosition(
          points.first,
          _getRotateAngle(_currentPosition?.heading?.trueHeading ??
              _currentPosition?.bearing ??
              0));
    });
  }

  /// this function return the angle of the marker relative to the map.ß
  /// which present the angle of user and angle of the map to north pole
  /// [bearing] is the angle of the marker relative to the north pole
  /// [(_mapController.cameraPosition?.bearing ?? 0)] is the angle of the map relative to the north pole
  double _getRotateAngle(double bearing) {
    /// The modulo operation (% 360.0) ensures that the resulting angle is in the range [0, 360).
    /// The Transform.rotate widget takes the rotation angle in radians, so we
    /// need to convert the angle from degrees to radians by multiplying it by [(pi / 180.0).]
    ///
    /// [bearing - (_mapController.cameraPosition?.bearing ?? 0)] is the angle of the marker relative to the map.
    /// which present the angle of user and angle of the map to north pole

    return ((bearing - (_mapController.cameraPosition?.bearing ?? 0)) % 360) *
        pi /
        180;
  }

  _updatePulseSize() {
    double width = _currentPosition?.horizontalAccuracy ?? 0;
    double height = _currentPosition?.verticalAccuracy ?? 0;
    // max of width and height
    width = max(width, height);
    double zoomLevel = _mapController.cameraPosition?.zoom ?? 0;
    // convert from meter to pixel with zoom level

    if (mounted)
      setState(() {
        _pulseSize = width / 38543 * pow(2, zoomLevel);
      });
  }

  Widget _updateUserLocationWidget() {
    if (widget.locationIcon != null && widget.bearingIcon != null) {
      _child = SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: IgnorePointer(
          ignoring: widget.ignorePointer ?? true,
          child: Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  size: Size(_pulseSize, _pulseSize),
                  painter: CirclePainter(
                    radius: _pulseSize / 2,
                    color: widget.pulseColor.withOpacity(widget.pulseOpacity),
                  ),
                ),
              ),
              widget.locationIcon!,
              widget.bearingIcon!,
            ],
          ),
        ),
      );
    } else {
      _child = Stack(
        alignment: AlignmentDirectional.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: _iconSize,
            height: _iconSize,
            decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10)),
          ),
          // draw a bearing angle icon with a triangle anchor is 60
          Container(
              width: _iconSize,
              height: _iconSize,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.arrow_upward, color: Colors.white)),
        ],
      );
    }
    return _child!;
  }

  @override
  Widget build(BuildContext context) {
    return _location != null && _initialPosition != null
        ? MarkerWidget(
            key: 'vietmapLocationMarker2024',
            coordinate: _location!,
            initialPosition: _initialPosition!,
            angle: _getRotateAngle(_currentPosition?.bearing ??
                _currentPosition?.heading?.trueHeading ??
                0),
            addMarkerState: (_) {
              _positionMarkerStates = _;
            },
            tiltRotate: _mapController._cameraPosition?.tilt ?? 0,
            alignment: Alignment.center,
            child: _updateUserLocationWidget(),
            width: _iconSize,
            height: _iconSize)
        : SizedBox.shrink();
  }
}
