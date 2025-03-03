// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package vn.vietmap.vietmapgl

import vn.vietmap.vietmapsdk.geometry.LatLngBounds
import vn.vietmap.vietmapsdk.location.engine.LocationEngineRequest

/** Receiver of VietmapGL configuration options.  */
internal interface VietmapGLMapOptionsSink {
    // todo: dddd replace with CameraPosition.Builder target
    fun setCameraTargetBounds(bounds: LatLngBounds)

    fun setCompassEnabled(compassEnabled: Boolean)

    // TODO: styleString is not actually a part of options. consider moving
    fun setStyleString(styleString: String)

    fun setMinMaxZoomPreference(min: Float?, max: Float?)

    fun setRotateGesturesEnabled(rotateGesturesEnabled: Boolean)

    fun setScrollGesturesEnabled(scrollGesturesEnabled: Boolean)

    fun setTiltGesturesEnabled(tiltGesturesEnabled: Boolean)

    fun setTrackCameraPosition(trackCameraPosition: Boolean)

    fun setZoomGesturesEnabled(zoomGesturesEnabled: Boolean)

    fun setMyLocationEnabled(myLocationEnabled: Boolean)

    fun setMyLocationTrackingMode(myLocationTrackingMode: Int)

    fun setMyLocationRenderMode(myLocationRenderMode: Int)

    fun setLogoViewMargins(x: Int, y: Int)

    fun setCompassGravity(gravity: Int)

    fun setCompassViewMargins(x: Int, y: Int)

    fun setAttributionButtonGravity(gravity: Int)

    fun setAttributionButtonMargins(x: Int, y: Int)

    fun setLocationEngineProperties(locationEngineRequest: LocationEngineRequest)
}