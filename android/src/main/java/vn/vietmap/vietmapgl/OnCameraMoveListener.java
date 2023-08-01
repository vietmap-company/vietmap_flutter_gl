// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package vn.vietmap.vietmapgl;

import vn.vietmap.vietmapsdk.camera.CameraPosition;

interface OnCameraMoveListener {
  void onCameraMoveStarted(boolean isGesture);

  void onCameraMove(CameraPosition newPosition);

  void onCameraIdle();
}
