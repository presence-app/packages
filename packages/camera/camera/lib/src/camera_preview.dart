// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../camera.dart';

/// A widget showing a live camera preview.
class CameraPreview extends StatelessWidget {
  /// Creates a preview widget for the given camera controller.
  const CameraPreview(this.controller, {super.key, this.child});

  /// The controller for the camera that the preview is shown for.
  final CameraController controller;

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
          _isLandscape()
              ? (1 / controller.value.aspectRatio) //controller.value.aspectRatio
              : (1 / controller.value.aspectRatio), // 1 / controller.value.aspectRatio)

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

    /* TESTING - This might be useful in case we need to do things here
    if (controller.value.deviceOrientation == DeviceOrientation.portraitUp) {
      debugPrint("CameraPreview: up");
      return 0;
    } else if (controller.value.deviceOrientation ==
        DeviceOrientation.landscapeRight) {
      debugPrint("CameraPreview: right");
      /*
      controller.value = controller.value.copyWith(
        deviceOrientation: DeviceOrientation.landscapeRight,
          lockedCaptureOrientation: const Optional<DeviceOrientation>.absent(),
         previewSize: Size(controller.value.previewSize!.height, controller.value.previewSize!.width)
      );
       */
      return 3;
    } else
    if (controller.value.deviceOrientation == DeviceOrientation.portraitDown) {
      debugPrint("CameraPreview: down");
      return 2;
    }
    else
    if (controller.value.deviceOrientation == DeviceOrientation.landscapeLeft) {
      debugPrint("CameraPreview: left");
      return 5;
    } else {
      return 0;
    }
  */


    final Map<DeviceOrientation, int> turns = <DeviceOrientation, int>{
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeRight: 3,
      DeviceOrientation.portraitDown: 2,
      DeviceOrientation.landscapeLeft: 5,
    };
    return turns[_getApplicableOrientation()]!;
  }

  DeviceOrientation _getApplicableOrientation() {
    return controller.value.isRecordingVideo
        ? controller.value.recordingOrientation!
        : (controller.value.previewPauseOrientation ??
            controller.value.lockedCaptureOrientation ??
            controller.value.deviceOrientation);
  }
}
