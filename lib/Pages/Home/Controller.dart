import 'dart:async';
import 'dart:io';

import 'package:camera_camera/page/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pto_photo/Models/ItemPhoto.dart';
import 'package:pto_photo/Pages/GoogleMapPage/GoogleMapPage.dart';

class HomeController {
  HomeController() {
    list = [];
    _streamController.sink.add(list);
  }

  List<ItemPhoto> list;

  final _streamController = StreamController<List<ItemPhoto>>.broadcast();

  get stream => _streamController.stream;

  addPhoto(BuildContext context, Widget mask) async {
    File newFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Camera(
          imageMask: mask,
          mode: CameraMode.fullscreen,
          enableCameraChange: false,
        ),
      ),
    );
    if (newFile != null) {
      ItemPhoto step = ItemPhoto(newFile);
      if (await step.initLocation()) {
        list.add(step);
        _streamController.sink.add(list);
        await list[list.length - 1].updateData();
        _streamController.sink.add(list);
      } else {
        print("NO LOCATION PERMISSION");
      }
    }
  }

  updatePosition(BuildContext context, int index) async {
    LatLng result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => GoogleMapPage(list[index])));
    if (result != null) {
      list[index].latLongU = result;
      list[index].markers = {
        Marker(
            markerId: MarkerId(list[index].markerId),
            position: list[index].latLongUser,
            draggable: false,
            onTap: () {})
      };
      print("USER VALUE " + list[index].latLongUser.toString());
    }
    _streamController.sink.add(list);
  }

  close() {
    _streamController.close();
  }
}
