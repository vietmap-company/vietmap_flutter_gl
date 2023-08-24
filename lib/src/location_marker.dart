// part of vietmap_flutter_gl;

// class LocationMarker extends StatefulWidget {
//   final Widget? locationIcon;
//   final Widget? bearingIcon;
//   final VietmapController mapController;

//   /// Set this value to true to ignore pointer events on the markers.
//   /// If you using a marker like a button and have a [GestureDetector] inside it,
//   /// set this value to false to prevent the map from receiving the gesture.
//   final bool? ignorePointer;

//   /// The markers to be placed on the map.
//   /// use [LocationMarker] inside a [Stack], that contain [VietmapGL] and [LocationMarker] to work properly
//   /// [VietmapGL.trackCameraPosition] must be set to true to work properly
//   const LocationMarker(
//       {Key? key,
//       this.locationIcon,
//       this.bearingIcon,
//       required this.mapController,
//       this.ignorePointer})
//       : super(key: key);

//   @override
//   State<LocationMarker> createState() => _LocationMarkerState();
// }

// class _LocationMarkerState extends State<LocationMarker> {
//   VietmapController get _mapController => widget.mapController;
//   MarkerWidget? _positionMarker;
//   MarkerState? _positionMarkerStates;
//   Position? currentPosition;
//   Widget? child;
//   @override
//   void didUpdateWidget(covariant LocationMarker oldWidget) {
//     if (widget.locationIcon != null && widget.bearingIcon != null) {
//       child = Stack(
//         children: [
//           widget.locationIcon!,
//           widget.bearingIcon!,
//         ],
//       );
//     } else {
//       child = Stack(
//         children: [
//           Container(
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//                 color: Colors.blue,
//                 border: Border.all(color: Colors.white, width: 2),
//                 borderRadius: BorderRadius.circular(10)),
//           ),
//           // draw a bearing angle icon with a triangle anchor is 60
//           Transform.translate(
//             offset: Offset(0, 10),
//             child: Transform.rotate(
//               // angle: res.heading * (pi / 180),
//               angle: currentPosition?.heading ?? 0,
//               child: Container(
//                   width: 20,
//                   height: 20,
//                   decoration: BoxDecoration(
//                       color: Colors.blue,
//                       border: Border.all(color: Colors.white, width: 2),
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Icon(Icons.arrow_upward, color: Colors.white)),
//             ),
//           ),
//         ],
//       );
//     }
//     if (currentPosition == null) return;
//     LatLng location =
//         LatLng(currentPosition!.latitude, currentPosition!.longitude);
//     _mapController.toScreenLocationBatch([location]).then((value) {
//       _positionMarker = MarkerWidget(
//           key: 'vietmapLocationMarker2023',
//           coordinate: location,
//           initialPosition: value.first,
//           addMarkerState: (_) {
//             _positionMarkerStates = _;
//           },
//           child: child!,
//           width: 20,
//           height: 20);
//     });
//     super.didUpdateWidget(oldWidget);
//   }

//   Function()? onMapListener;
//   Function(CameraPosition?)? onLocationMarkerListener;

//   @override
//   void initState() {
//     onMapListener = () {
//       if (_mapController.isCameraMoving) {
//         _updateMarkerPosition();
//       }
//     };
//     onLocationMarkerListener = (cameraPosition) {
//       _updateMarkerPosition();
//     };
//     _mapController.getPlatform.onCameraIdlePlatform
//         .add(onLocationMarkerListener!);
//     _mapController.addListener(onMapListener!);

//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//     //   await Geolocator.getPositionStream().listen((event) {
//     //     setState(() {
//     //       currentPosition = event;
//     //     });
//     //   });

//     //   if (widget.locationIcon != null && widget.bearingIcon != null) {
//     //     child = Stack(
//     //       children: [
//     //         widget.locationIcon!,
//     //         widget.bearingIcon!,
//     //       ],
//     //     );
//     //   } else {
//     //     child = Stack(
//     //       children: [
//     //         Container(
//     //           width: 20,
//     //           height: 20,
//     //           decoration: BoxDecoration(
//     //               color: Colors.blue,
//     //               border: Border.all(color: Colors.white, width: 2),
//     //               borderRadius: BorderRadius.circular(10)),
//     //         ),
//     //         // draw a bearing angle icon with a triangle anchor is 60
//     //         Transform.translate(
//     //           offset: Offset(0, 10),
//     //           child: Transform.rotate(
//     //             // angle: res.heading * (pi / 180),
//     //             angle: currentPosition?.heading ?? 0,
//     //             child: Container(
//     //                 width: 20,
//     //                 height: 20,
//     //                 decoration: BoxDecoration(
//     //                     color: Colors.blue,
//     //                     border: Border.all(color: Colors.white, width: 2),
//     //                     borderRadius: BorderRadius.circular(10)),
//     //                 child: Icon(Icons.arrow_upward, color: Colors.white)),
//     //           ),
//     //         ),
//     //       ],
//     //     );
//     //   }
//     //   if (currentPosition == null) return;
//     //   LatLng location =
//     //       LatLng(currentPosition!.latitude, currentPosition!.longitude);
//     //   _mapController.toScreenLocationBatch([location]).then((value) {
//     //     _positionMarker = MarkerWidget(
//     //         key: 'vietmapLocationMarker2023',
//     //         coordinate: location,
//     //         initialPosition: value.first,
//     //         addMarkerState: (_) {
//     //           _positionMarkerStates = _;
//     //         },
//     //         child: child!,
//     //         width: 20,
//     //         height: 20);
//     //   });
//     //   if (Platform.isIOS) {
//     //     await Future.delayed(Duration(milliseconds: 100));
//     //   }

//     //   _mapController.toScreenLocationBatch([location]).then((value) {
//     //     _positionMarker = MarkerWidget(
//     //         key: 'vietmapLocationMarker2024',
//     //         coordinate: location,
//     //         initialPosition: value.first,
//     //         addMarkerState: (_) {
//     //           _positionMarkerStates = _;
//     //         },
//     //         child: child!,
//     //         width: 20,
//     //         height: 20);
//     //   });

//     //   _mapController.toScreenLocationBatch([location]).then((value) {
//     //     if (value.isEmpty) return;
//     //     var point =
//     //         Point<double>(value.first.x as double, value.first.y as double);
//     //     _positionMarker = MarkerWidget(
//     //         key: 'vietmapLocationMarker2024',
//     //         coordinate: location,
//     //         initialPosition: value.first,
//     //         addMarkerState: (_) {
//     //           _positionMarkerStates = _;
//     //         },
//     //         child: child!,
//     //         width: 20,
//     //         height: 20);
//     //   });
//     // });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _mapController.getPlatform.onCameraIdlePlatform
//         .remove(onLocationMarkerListener!);
//     _mapController.removeListener(onMapListener!);
//     super.dispose();
//   }

//   void _updateMarkerPosition() {
//     final coordinates = <LatLng>[];

//     if (_positionMarkerStates != null)
//       coordinates.add(_positionMarkerStates!.getCoordinate());

//     _mapController.toScreenLocationBatch(coordinates).then((points) {
//       if (points.isEmpty || _positionMarkerStates == null) return;
//       _positionMarkerStates!.updatePosition(points.first);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//         ignoring: widget.ignorePointer ?? false,
//         child: Column(
//           children: [
//             _positionMarker ?? SizedBox.shrink(),
//           ],
//         ));
//   }
// }
