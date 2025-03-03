import 'package:js/js_util.dart';
import 'package:vietmap_flutter_gl_web/src/geo/lng_lat.dart';
import 'package:vietmap_flutter_gl_web/src/geo/lng_lat_bounds.dart';
import 'package:vietmap_flutter_gl_web/src/geo/point.dart';
import 'package:vietmap_flutter_gl_web/src/interop/interop.dart';
import 'package:vietmap_flutter_gl_web/src/ui/map.dart';
import 'package:vietmap_flutter_gl_web/src/util/evented.dart';

///  Options common to {@link VietmapGL#jumpTo}, [VietmapGL.easeTo], and {@link VietmapGL#flyTo}, controlling the desired location,
///  zoom, bearing, and pitch of the camera. All properties are optional, and when a property is omitted, the current
///  camera value for that property will remain unchanged.
///
///  @typedef {Object} CameraOptions
///  @property {LngLatLike} center The desired center.
///  @property {number} zoom The desired zoom level.
///  @property {number} bearing The desired bearing, in degrees. The bearing is the compass direction that
///  is "up"; for example, a bearing of 90° orients the map so that east is up.
///  @property {number} pitch The desired pitch, in degrees.
///  @property {LngLatLike} around If `zoom` is specified, `around` determines the point around which the zoom is centered.

class CameraOptions extends JsObjectWrapper<CameraOptionsJsImpl> {
  LngLat get center => LngLat.fromJsObject(jsObject.center);

  num get zoom => jsObject.zoom;

  num get bearing => jsObject.bearing;

  num get pitch => jsObject.pitch;

  LngLat get around => LngLat.fromJsObject(jsObject.around);

  factory CameraOptions({
    LngLat? center,
    num? zoom,
    num? bearing,
    num? pitch,
    LngLat? around,
  }) =>
      CameraOptions.fromJsObject(CameraOptionsJsImpl(
        center: center?.jsObject,
        zoom: zoom,
        bearing: bearing,
        pitch: pitch,
        around: around?.jsObject,
      ));

  /// Creates a new CameraOptions from a [jsObject].
  CameraOptions.fromJsObject(super.jsObject) : super.fromJsObject();
}

///  Options common to map movement methods that involve animation, such as {@link VietmapGL#panBy} and
///  [VietmapGL.easeTo], controlling the duration and easing function of the animation. All properties
///  are optional.
///
///  @typedef {Object} AnimationOptions
///  @property {number} duration The animation's duration, measured in milliseconds.
///  @property {Function} easing A function taking a time in the range 0..1 and returning a number where 0 is
///    the initial state and 1 is the final state.
///  @property {PointLike} offset of the target center relative to real map container center at the end of animation.
///  @property {boolean} animate If `false`, no animation will occur.
///  @property {boolean} essential If `true`, then the animation is considered essential and will not be affected by
///    [`prefers-reduced-motion`](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion).
class AnimationOptions extends JsObjectWrapper<AnimationOptionsJsImpl> {
  num get duration => jsObject.duration;

  num Function(num time) get easing => jsObject.easing;

  Point get offset => Point.fromJsObject(jsObject.offset);

  bool get animate => jsObject.animate;

  bool get essential => jsObject.essential;

  factory AnimationOptions({
    num? duration,
    num Function(num time)? easing,
    required Point offset,
    bool? animate,
    bool? essential,
  }) =>
      AnimationOptions.fromJsObject(AnimationOptionsJsImpl(
        duration: duration,
        easing: easing,
        offset: offset.jsObject,
        animate: animate,
        essential: essential,
      ));

  /// Creates a new AnimationOptions from a [jsObject].
  AnimationOptions.fromJsObject(super.jsObject) : super.fromJsObject();
}

///  Options for setting padding on a call to {@link VietmapGL#fitBounds}. All properties of this object must be
///  non-negative integers.
///
///  @typedef {Object} PaddingOptions
///  @property {number} top Padding in pixels from the top of the map canvas.
///  @property {number} bottom Padding in pixels from the bottom of the map canvas.
///  @property {number} left Padding in pixels from the left of the map canvas.
///  @property {number} right Padding in pixels from the right of the map canvas.
class PaddingOptions extends JsObjectWrapper<PaddingOptionsJsImpl> {
  num get top => jsObject.top;

  num get bottom => jsObject.bottom;

  num get left => jsObject.left;

  num get right => jsObject.right;

  factory PaddingOptions({
    num? top,
    num? bottom,
    num? left,
    num? right,
  }) =>
      PaddingOptions.fromJsObject(PaddingOptionsJsImpl(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ));

  /// Creates a new PaddingOptions from a [jsObject].
  PaddingOptions.fromJsObject(super.jsObject) : super.fromJsObject();
}

class Camera extends Evented {
  @override
  final CameraJsImpl jsObject;

  ///  Returns the map's geographical centerpoint.
  ///
  ///  @memberof VietmapGL#
  ///  @returns The map's geographical centerpoint.
  LngLat getCenter() => LngLat.fromJsObject(jsObject.getCenter());

  ///  Sets the map's geographical centerpoint. Equivalent to `jumpTo({center: center})`.
  ///
  ///  @memberof VietmapGL#
  ///  @param center The centerpoint to set.
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  ///  @example
  ///  map.setCenter([-74, 38]);
  VietmapGL setCenter(LngLat center, [dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.setCenter(center.jsObject));

  ///  Pans the map by the specified offset.
  ///
  ///  @memberof VietmapGL#
  ///  @param offset `x` and `y` coordinates by which to pan the map.
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  ///  @see [Navigate the map with game-like controls](https://maplibre.org/maplibre-gl-js/docs/examples/game-controls/)
  VietmapGL panBy(Point offset,
          [AnimationOptions? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.panBy(offset.jsObject));

  ///  Pans the map to the specified location, with an animated transition.
  ///
  ///  @memberof VietmapGL#
  ///  @param lnglat The location to pan the map to.
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  VietmapGL panTo(LngLat lnglat,
          [AnimationOptions? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.panTo(lnglat.jsObject));

  ///  Returns the map's current zoom level.
  ///
  ///  @memberof VietmapGL#
  ///  @returns The map's current zoom level.
  num getZoom() => jsObject.getZoom();

  ///  Sets the map's zoom level. Equivalent to `jumpTo({zoom: zoom})`.
  ///
  ///  @memberof VietmapGL#
  ///  @param zoom The zoom level to set (0-20).
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires zoomstart
  ///  @fires move
  ///  @fires zoom
  ///  @fires moveend
  ///  @fires zoomend
  ///  @returns {VietmapGL} `this`
  ///  @example
  ///  // zoom the map to 5
  ///  map.setZoom(5);
  VietmapGL setZoom(num zoom, [dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.setZoom(zoom));

  ///  Zooms the map to the specified zoom level, with an animated transition.
  ///
  ///  @memberof VietmapGL#
  ///  @param zoom The zoom level to transition to.
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires zoomstart
  ///  @fires move
  ///  @fires zoom
  ///  @fires moveend
  ///  @fires zoomend
  ///  @returns {VietmapGL} `this`
  VietmapGL zoomTo(num zoom, [AnimationOptions? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.zoomTo(zoom));

  ///  Increases the map's zoom level by 1.
  ///
  ///  @memberof VietmapGL#
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires zoomstart
  ///  @fires move
  ///  @fires zoom
  ///  @fires moveend
  ///  @fires zoomend
  ///  @returns {VietmapGL} `this`
  VietmapGL zoomIn([AnimationOptions? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.zoomIn());

  ///  Decreases the map's zoom level by 1.
  ///
  ///  @memberof VietmapGL#
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires zoomstart
  ///  @fires move
  ///  @fires zoom
  ///  @fires moveend
  ///  @fires zoomend
  ///  @returns {VietmapGL} `this`
  VietmapGL zoomOut([AnimationOptions? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.zoomOut());

  ///  Returns the map's current bearing. The bearing is the compass direction that is \"up\"; for example, a bearing
  ///  of 90° orients the map so that east is up.
  ///
  ///  @memberof VietmapGL#
  ///  @returns The map's current bearing.
  ///  @see [Navigate the map with game-like controls](https://maplibre.org/maplibre-gl-js/docs/examples/game-controls/)
  num getBearing() => jsObject.getBearing();

  ///  Sets the map's bearing (rotation). The bearing is the compass direction that is \"up\"; for example, a bearing
  ///  of 90° orients the map so that east is up.
  ///
  ///  Equivalent to `jumpTo({bearing: bearing})`.
  ///
  ///  @memberof VietmapGL#
  ///  @param bearing The desired bearing.
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  ///  @example
  ///  // rotate the map to 90 degrees
  ///  map.setBearing(90);
  VietmapGL setBearing(num bearing, [dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.setBearing(bearing));

  ///  Rotates the map to the specified bearing, with an animated transition. The bearing is the compass direction
  ///  that is \"up\"; for example, a bearing of 90° orients the map so that east is up.
  ///
  ///  @memberof VietmapGL#
  ///  @param bearing The desired bearing.
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  VietmapGL rotateTo(num bearing,
          [AnimationOptions? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.rotateTo(bearing));

  ///  Rotates the map so that north is up (0° bearing), with an animated transition.
  ///
  ///  @memberof VietmapGL#
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  VietmapGL resetNorth([AnimationOptions? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.resetNorth());

  ///  Rotates and pitches the map so that north is up (0° bearing) and pitch is 0°, with an animated transition.
  ///
  ///  @memberof VietmapGL#
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  VietmapGL resetNorthPitch([AnimationOptions? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.resetNorthPitch());

  ///  Snaps the map so that north is up (0° bearing), if the current bearing is close enough to it (i.e. within the
  ///  `bearingSnap` threshold).
  ///
  ///  @memberof VietmapGL#
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  VietmapGL snapToNorth([AnimationOptions? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.snapToNorth());

  ///  Returns the map's current pitch (tilt).
  ///
  ///  @memberof VietmapGL#
  ///  @returns The map's current pitch, measured in degrees away from the plane of the screen.
  num getPitch() => jsObject.getPitch();

  ///  Sets the map's pitch (tilt). Equivalent to `jumpTo({pitch: pitch})`.
  ///
  ///  @memberof VietmapGL#
  ///  @param pitch The pitch to set, measured in degrees away from the plane of the screen (0-60).
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires pitchstart
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  VietmapGL setPitch(num pitch, [dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.setPitch(pitch));

  ///  @memberof VietmapGL#
  ///  @param {LatLngBoundsLike} bounds Calculate the center for these bounds in the viewport and use
  ///       the highest zoom level up to and including `VietmapGL#getMaxZoom()` that fits
  ///       in the viewport. LatLngBounds represent a box that is always axis-aligned with bearing 0.
  ///  @param options
  ///  @param {number | PaddingOptions} `options.padding` The amount of padding in pixels to add to the given bounds.
  ///  @param {PointLike} `options.offset=[0, 0]` The center of the given bounds relative to the map's center, measured in pixels.
  ///  @param {number} `options.maxZoom` The maximum zoom level to allow when the camera would transition to the specified bounds.
  ///  @returns {CameraOptions | void} If map is able to fit to provided bounds, returns `CameraOptions` with
  ///       `center`, `zoom`, and `bearing`. If map is unable to fit, method will warn and return undefined.
  ///  @example
  ///  var bbox = [[-79, 43], [-73, 45]];
  ///  var newCameraTransform = map.cameraForBounds(bbox, {
  ///    padding: {top: 10, bottom:25, left: 15, right: 5}
  ///  });
  CameraOptions cameraForBounds(LngLatBounds bounds, [dynamic options]) {
    if (options == null) {
      return CameraOptions.fromJsObject(
          jsObject.cameraForBounds(bounds.jsObject));
    }
    return CameraOptions.fromJsObject(jsObject.cameraForBounds(bounds.jsObject,
        options is CameraOptions ? options.jsObject : jsify(options)));
  }

  ///  Pans and zooms the map to contain its visible area within the specified geographical bounds.
  ///  This function will also reset the map's bearing to 0 if bearing is nonzero.
  ///
  ///  @memberof VietmapGL#
  ///  @param bounds Center these bounds in the viewport and use the highest
  ///       zoom level up to and including `VietmapGL#getMaxZoom()` that fits them in the viewport.
  ///  @param {Object} [options] Options supports all properties from {@link AnimationOptions} and {@link CameraOptions} in addition to the fields below.
  ///  @param {number | PaddingOptions} `options.padding` The amount of padding in pixels to add to the given bounds.
  ///  @param {boolean} `options.linear=false` If `true`, the map transitions using
  ///      [VietmapGL.easeTo]. If `false`, the map transitions using {@link VietmapGL#flyTo}. See
  ///      those functions and {@link AnimationOptions} for information about options available.
  ///  @param {Function} `options.easing` An easing function for the animated transition. See {@link AnimationOptions}.
  ///  @param {PointLike} `options.offset=[0, 0]` The center of the given bounds relative to the map's center, measured in pixels.
  ///  @param {number} `options.maxZoom` The maximum zoom level to allow when the map view transitions to the specified bounds.
  ///  @param {Object} [eventData] Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  ///  @example
  ///  var bbox = [[-79, 43], [-73, 45]];
  ///  map.fitBounds(bbox, {
  ///    padding: {top: 10, bottom:25, left: 15, right: 5}
  ///  });
  ///  @see [Fit a map to a bounding box](https://maplibre.org/maplibre-gl-js/docs/examples/fitbounds/)
  VietmapGL fitBounds(LngLatBounds bounds,
          [Map<String, dynamic>? options, dynamic eventData]) =>
      VietmapGL.fromJsObject(
          jsObject.fitBounds(bounds.jsObject, jsify(options ?? {}), eventData));

  ///  Pans, rotates and zooms the map to to fit the box made by points p0 and p1
  ///  once the map is rotated to the specified bearing. To zoom without rotating,
  ///  pass in the current map bearing.
  ///
  ///  @memberof VietmapGL#
  ///  @param p0 First point on screen, in pixel coordinates
  ///  @param p1 Second point on screen, in pixel coordinates
  ///  @param bearing Desired map bearing at end of animation, in degrees
  ///  @param options
  ///  @param {number | PaddingOptions} `options.padding` The amount of padding in pixels to add to the given bounds.
  ///  @param {boolean} `options.linear=false` If `true`, the map transitions using
  ///      [VietmapGL.easeTo]. If `false`, the map transitions using {@link VietmapGL#flyTo}. See
  ///      those functions and {@link AnimationOptions} for information about options available.
  ///  @param {Function} `options.easing` An easing function for the animated transition. See {@link AnimationOptions}.
  ///  @param {PointLike} `options.offset=[0, 0]` The center of the given bounds relative to the map's center, measured in pixels.
  ///  @param {number} `options.maxZoom` The maximum zoom level to allow when the map view transitions to the specified bounds.
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires moveend
  ///  @returns {VietmapGL} `this`
  ///  @example
  ///  var p0 = [220, 400];
  ///  var p1 = [500, 900];
  ///  map.fitScreenCoordinates(p0, p1, map.getBearing(), {
  ///    padding: {top: 10, bottom:25, left: 15, right: 5}
  ///  });
  ///  @see [Used by BoxZoomHandler](https://maplibre.org/maplibre-gl-js/docs/API/classes/maplibregl.BoxZoomHandler/)
  VietmapGL fitScreenCoordinates(Point p0, Point p1, num bearing,
          [dynamic options, dynamic eventData]) =>
      VietmapGL.fromJsObject(
          jsObject.fitScreenCoordinates(p0.jsObject, p1.jsObject, bearing));

  ///  Changes any combination of center, zoom, bearing, and pitch, without
  ///  an animated transition. The map will retain its current values for any
  ///  details not specified in [options].
  ///
  ///  @memberof VietmapGL#
  ///  @param options
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires zoomstart
  ///  @fires pitchstart
  ///  @fires rotate
  ///  @fires move
  ///  @fires zoom
  ///  @fires pitch
  ///  @fires moveend
  ///  @fires zoomend
  ///  @fires pitchend
  ///  @returns {VietmapGL} `this`
  VietmapGL jumpTo(CameraOptions options, [dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.jumpTo(options.jsObject));

  ///  Changes any combination of center, zoom, bearing, and pitch, with an animated transition
  ///  between old and new values. The map will retain its current values for any
  ///  details not specified in [options].
  ///
  ///  Note: The transition will happen instantly if the user has enabled
  ///  the `reduced motion` accesibility feature enabled in their operating system.
  ///
  ///  @memberof VietmapGL#
  ///  @param options Options describing the destination and animation of the transition.
  ///             Accepts {@link CameraOptions} and {@link AnimationOptions}.
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires zoomstart
  ///  @fires pitchstart
  ///  @fires rotate
  ///  @fires move
  ///  @fires zoom
  ///  @fires pitch
  ///  @fires moveend
  ///  @fires zoomend
  ///  @fires pitchend
  ///  @returns {VietmapGL} `this`
  ///  @see [Navigate the map with game-like controls](https://maplibre.org/maplibre-gl-js/docs/examples/game-controls/)
  VietmapGL easeTo(dynamic options, [dynamic eventData]) =>
      VietmapGL.fromJsObject(jsObject.easeTo(options));

  ///  Changes any combination of center, zoom, bearing, and pitch, animating the transition along a curve that
  ///  evokes flight. The animation seamlessly incorporates zooming and panning to help
  ///  the user maintain her bearings even after traversing a great distance.
  ///
  ///  Note: The animation will be skipped, and this will behave equivalently to `jumpTo`
  ///  if the user has the `reduced motion` accesibility feature enabled in their operating system.
  ///
  ///  @memberof VietmapGL#
  ///  @param {Object} options Options describing the destination and animation of the transition.
  ///      Accepts {@link CameraOptions}, {@link AnimationOptions},
  ///      and the following additional options.
  ///  @param {number} [options.curve=1.42] The zooming "curve" that will occur along the
  ///      flight path. A high value maximizes zooming for an exaggerated animation, while a low
  ///      value minimizes zooming for an effect closer to [VietmapGL.easeTo]. 1.42 is the average
  ///      value selected by participants in the user study discussed in
  ///      [van Wijk (2003)](https://www.win.tue.nl/~vanwijk/zoompan.pdf). A value of
  ///      `Math.pow(6, 0.25)` would be equivalent to the root mean squared average velocity. A
  ///      value of 1 would produce a circular motion.
  ///  @param {number} `options.minZoom` The zero-based zoom level at the peak of the flight path. If
  ///      `options.curve` is specified, this option is ignored.
  ///  @param {number} `options.speed=1.2` The average speed of the animation defined in relation to
  ///      `options.curve`. A speed of 1.2 means that the map appears to move along the flight path
  ///      by 1.2 times `options.curve` screenfuls every second. A _screenful_ is the map's visible span.
  ///      It does not correspond to a fixed physical distance, but varies by zoom level.
  ///  @param {number} `options.screenSpeed` The average speed of the animation measured in screenfuls
  ///      per second, assuming a linear timing curve. If `options.speed` is specified, this option is ignored.
  ///  @param {number} `options.maxDuration` The animation's maximum duration, measured in milliseconds.
  ///      If duration exceeds maximum duration, it resets to 0.
  ///  @param eventData Additional properties to be added to event objects of events triggered by this method.
  ///  @fires movestart
  ///  @fires zoomstart
  ///  @fires pitchstart
  ///  @fires move
  ///  @fires zoom
  ///  @fires rotate
  ///  @fires pitch
  ///  @fires moveend
  ///  @fires zoomend
  ///  @fires pitchend
  ///  @returns {VietmapGL} `this`
  ///  @example
  ///  // fly with default options to null island
  ///  map.flyTo({center: [0, 0], zoom: 9});
  ///  // using flyTo options
  ///  map.flyTo({
  ///    center: [0, 0],
  ///    zoom: 9,
  ///    speed: 0.2,
  ///    curve: 1,
  ///    easing(t) {
  ///      return t;
  ///    }
  ///  });
  ///  @see [Fly to a location](https://maplibre.org/maplibre-gl-js/docs/examples/flyto/)
  ///  @see [Slowly fly to a location](https://maplibre.org/maplibre-gl-js/docs/examples/flyto-options/)
  ///  @see [Fly to a location based on scroll position](https://maplibre.org/maplibre-gl-js/docs/examples/scroll-fly-to/)
  VietmapGL flyTo(dynamic options, [String? eventData]) =>
      VietmapGL.fromJsObject(jsObject
          .flyTo(options is CameraOptions ? options.jsObject : jsify(options)));

  bool isEasing() => jsObject.isEasing();

  ///  Stops any animated transition underway.
  ///
  ///  @memberof VietmapGL#
  ///  @returns {VietmapGL} `this`
  VietmapGL stop() => VietmapGL.fromJsObject(jsObject.stop());

  /// Creates a new Camera from a [jsObject].
  Camera.fromJsObject(this.jsObject) : super.fromJsObject(jsObject);
}
