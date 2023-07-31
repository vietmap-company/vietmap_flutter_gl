// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart'; // ignore: unnecessary_import
// import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

// import 'components/marker.dart';
// import 'page.dart';

// class MarkerLayer extends StatefulWidget {
//   MarkerLayer(
//       {required this.onMapCreated,
//       required this.onCameraIdleCallback,
//       required this.mapController});
//   final VietmapController mapController;
//   final Function(VietmapController) onMapCreated;
//   final VoidCallback onCameraIdleCallback;

//   @override
//   State<MarkerLayer> createState() => _MarkerLayerState();
// }

// class _MarkerLayerState extends State<MarkerLayer> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomMarker(mapController: widget.mapController);
//   }
// }

// class CustomMarker extends StatefulWidget {
//   const CustomMarker({required this.mapController});
//   final VietmapController mapController;
//   @override
//   State createState() => CustomMarkerState();
// }

// class CustomMarkerState extends State<CustomMarker> {
//   final Random _rnd = new Random();

//   VietmapController? _mapController;
//   List<Marker> _markers = [];
//   List<MarkerState> _markerStates = [];

//   @override
//   void initState() {
//     _mapController = widget.mapController;
//     _mapController?.getPlatform.onCameraIdlePlatform.add((cameraPosition) {
//       _updateMarkerPosition();
//     });
//     _mapController?.getPlatform.onCameraIdlePlatform.add((cameraPosition) {
//       _updateMarkerPosition();
//     });
//     _mapController?.addListener(() {
//       if (_mapController?.isCameraMoving ?? false) {
//         _updateMarkerPosition();
//       }
//     });
//     _addMarker(Point<double>(0, 0), LatLng(35.0, 135.0));
//     super.initState();
//   }

//   void _addMarkerStates(MarkerState markerState) {
//     _markerStates.add(markerState);
//   }

//   void _onMapCreated(VietmapController controller) {
//     _mapController = controller;
//     controller.addListener(() {
//       if (controller.isCameraMoving) {
//         _updateMarkerPosition();
//       }
//     });
//   }

//   void _onCameraIdleCallback() {
//     _updateMarkerPosition();
//   }

//   void _updateMarkerPosition() {
//     final coordinates = <LatLng>[];

//     for (final markerState in _markerStates) {
//       coordinates.add(markerState.getCoordinate());
//     }

//     _mapController?.toScreenLocationBatch(coordinates).then((points) {
//       _markerStates.asMap().forEach((i, value) {
//         _markerStates[i].updatePosition(points[i]);
//       });
//     });
//   }

//   void _addMarker(Point<double> point, LatLng coordinates) {
//     setState(() {
//       _markers.add(Marker(
//         key: _rnd.nextInt(100000).toString(),
//         coordinate: coordinates,
//         initialPosition: point,
//         addMarkerState: _addMarkerStates,
//         child: Icon(Icons.location_on),
//       ));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _updateMarkerPosition();
//     return IgnorePointer(
//         ignoring: true,
//         child: Stack(
//           children: _markers,
//         ));
//   }
// }

// // class Marker extends StatefulWidget {
// //   final Point _initialPosition;
// //   final LatLng _coordinate;
// //   final void Function(_MarkerState) _addMarkerState;

// //   Marker(
// //       String key, this._coordinate, this._initialPosition, this._addMarkerState)
// //       : super(key: Key(key));

// //   @override
// //   State<StatefulWidget> createState() {
// //     final state = _MarkerState(_initialPosition);
// //     _addMarkerState(state);
// //     return state;
// //   }
// // }

// // class _MarkerState extends State with TickerProviderStateMixin {
// //   final _iconSize = 20.0;

// //   Point _position;

// //   late AnimationController _controller;
// //   late Animation<double> _animation;

// //   _MarkerState(this._position);

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       duration: const Duration(seconds: 2),
// //       vsync: this,
// //     )..repeat(reverse: true);
// //     _animation = CurvedAnimation(
// //       parent: _controller,
// //       curve: Curves.elasticOut,
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     var ratio = 1.0;

// //     //web does not support Platform._operatingSystem
// //     if (!kIsWeb) {
// //       // iOS returns logical pixel while Android returns screen pixel
// //       ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
// //     }

// //     return Positioned(
// //         left: _position.x / ratio - _iconSize / 2,
// //         top: _position.y / ratio - _iconSize / 2,
// //         child: RotationTransition(
// //             turns: _animation,
// //             child: Image.asset('assets/symbols/2.0x/custom-icon.png',
// //                 height: _iconSize)));
// //   }

// //   void updatePosition(Point<num> point) {
// //     setState(() {
// //       _position = point;
// //     });
// //   }

// //   LatLng getCoordinate() {
// //     return (widget as Marker)._coordinate;
// //   }
// // }
