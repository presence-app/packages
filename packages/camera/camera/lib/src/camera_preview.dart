// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../camera.dart';

/// A widget showing a live camera preview.
/// Note: on iOS [deviceOrientation] must be set to null
/// coz the value will be fetched from [controller].
/// on Android [deviceOrientation] must be the current device
/// orientation correctly calculated by using device sensor
class CameraPreview extends StatelessWidget {
  /// Creates a preview widget for the given camera controller.
  const CameraPreview(
      this.controller,
      this.deviceOrientation,
      {super.key, this.child});

  /// The controller for the camera that the preview is shown for.
  final CameraController controller;

  /// The device orientation can be passed to force CameraPreview rotation
  final DeviceOrientation? deviceOrientation;

  /// A widget to overlay on top of the camera preview
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ?

    ValueListenableBuilder<CameraValue>(
      valueListenable: controller,
      builder: (BuildContext context, Object? value, Widget? child) {
        return AspectRatio(
          aspectRatio: (1 / controller.value.aspectRatio),

          /*
          aspectRatio: _isLandscape()
              ? controller.value.aspectRatio
              : (1 / controller.value.aspectRatio), //
          */

          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _wrapInRotatedBox(child: controller.buildPreview()),
              child ?? Container(),
            ],
          ),
        );
      },
      child: child,
    )
        : Container();
  }

  Widget _wrapInRotatedBox({required Widget child}) {
    // if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    //   return child;
    // }


    return RotatedBox(
      quarterTurns: _getQuarterTurns(),
      child: child,
    );
  }

  bool _isLandscape() {
    return <DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ].contains(_getApplicableOrientation());
  }



  int _getQuarterTurns() {

    final orientation = deviceOrientation ?? controller.value.deviceOrientation;
    // TESTING - This might be useful in case we need to do things here
    if (orientation == DeviceOrientation.portraitUp) {
      //debugPrint("CameraPreview: up");
      return 0;
    } else if (orientation ==
        DeviceOrientation.landscapeRight) {
      //debugPrint("CameraPreview: right");
      /*
      controller.value = controller.value.copyWith(
        deviceOrientation: DeviceOrientation.landscapeRight,
          lockedCaptureOrientation: const Optional<DeviceOrientation>.absent(),
         previewSize: Size(controller.value.previewSize!.height, controller.value.previewSize!.width)
      );
       */

      return defaultTargetPlatform == TargetPlatform.iOS ? 3 : 8;
    } else
    if (orientation == DeviceOrientation.portraitDown) {
      //debugPrint("CameraPreview: down");
      return defaultTargetPlatform == TargetPlatform.iOS ? 2 : 0;
    }
    else
    if (orientation == DeviceOrientation.landscapeLeft) {
      //debugPrint("CameraPreview: left");
      return defaultTargetPlatform == TargetPlatform.iOS ? 5 : 8;
    } else {
      return 0;
    }


    /* Disabled coz return value from code above
    final Map<DeviceOrientation, int> turns = <DeviceOrientation, int>{
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeRight: 3,
      DeviceOrientation.portraitDown: 2,
      DeviceOrientation.landscapeLeft: 5,
    };
    return turns[_getApplicableOrientation()]!;
    */
  }

  DeviceOrientation _getApplicableOrientation() {
    return controller.value.isRecordingVideo
        ? controller.value.recordingOrientation!
        : (controller.value.previewPauseOrientation ??
        controller.value.lockedCaptureOrientation ??
        controller.value.deviceOrientation);
  }
}
