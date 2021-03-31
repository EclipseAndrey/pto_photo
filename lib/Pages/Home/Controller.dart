import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera_camera/page/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pto_photo/Models/ItemPhoto.dart';
import 'package:pto_photo/Pages/GoogleMapPage/GoogleMapPage.dart';
import 'package:pto_photo/utils/DialogsIntegron/DialogIntegron.dart';
import 'package:pto_photo/utils/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pto_photo/Const.dart' as constants;
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:geodesy/geodesy.dart' as geo;

class HomeController {
  LatLng defaultPosition;
  bool auto;
  BuildContext context;
  bool orientation;


  HomeController(this.context) {
    list = [];
    _streamController.sink.add(list);
  }

  List<ItemPhoto> list;

  final _streamController = StreamController<List<ItemPhoto>>.broadcast();

  get stream => _streamController.stream;

  addPhoto(BuildContext context, Widget mask) async {
    if(defaultPosition != null ) {
      if((check(await getGPS(), defaultPosition))) {
        File newFile = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Camera(



                  imageMask: mask,
                  mode: CameraMode.fullscreen,
                  enableCameraChange: false,
                ),
          ),
        );
        if (newFile != null) {
          ItemPhoto step = ItemPhoto(newFile);
          if (await initDefaultPosition()) {
            step.latLongFirst = await getPosition();
            list.add(step);
            _streamController.sink.add(list);
            await list[list.length - 1].initLocation();
            await list[list.length - 1].updateExifData();
            _streamController.sink.add(list);
          } else {
            if (await initDefaultPosition()) {
              step.latLongFirst = await getPosition();
              list.add(step);
              _streamController.sink.add(list);
              await list[list.length - 1].initLocation();
              await list[list.length - 1].updateExifData();
              _streamController.sink.add(list);
            }

            print("NO LOCATION PERMISSION");
          }
        }
      }else{
        showDialogIntegronError(context, "Превышен радиус 200м");
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

  Future<bool> initDefaultPosition({LatLng position})async{
    final prefs = await SharedPreferences.getInstance();
    if(!(prefs.getBool(constants.statusPosition)??true)) {
      print("======== STATUS FALSE");
      auto = false;
      if (position != null) {
        defaultPosition = position;
        prefs.setString(
            constants.defaultPosition, json.encode(position.toJson()));
      } else if (prefs.getString(constants.defaultPosition) == null) {
        return await setDefaultPosition();
      } else {
        defaultPosition = LatLng.fromJson(
            json.decode(prefs.getString(constants.defaultPosition)));
      }
    }else{
      print("======== STATUS true");

      auto = true;
      defaultPosition = await getPosition();
      return true;
    }
    return true;
  }


  Future<LatLng> getPosition()async{
    if(auto){
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      LatLng defPos;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          //todo no Permission
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          //todo NoPermission
          return null;
        }
      }
      _locationData = await location.getLocation();
      print("Location" + _locationData.latitude.toString());
      defPos = LatLng(_locationData.latitude, _locationData.longitude);

      print("LOCATION " +
          _locationData.latitude.toString() +
          " " +
          _locationData.longitude.toString());

     return defPos;
    }else{
      return defaultPosition;
    }
  }



  Future<bool>setDefaultPosition()async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    LatLng defPos;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        //todo no Permission
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        //todo NoPermission
        return false;
      }
    }
    _locationData = await location.getLocation();
    print("Location" + _locationData.latitude.toString());
    defPos = LatLng(_locationData.latitude, _locationData.longitude);

    print("LOCATION " +
        _locationData.latitude.toString() +
        " " +
        _locationData.longitude.toString());

    initDefaultPosition(position: defPos);

    //GET ADDRESS

    // YandexGeocoder geocoder = YandexGeocoder(apiKey: ya_key);
    // GeocodeResponse geocodeFromPoint = await geocoder.getGeocode(GeocodeRequest(
    //   geocode: PointGeocode(
    //       latitude: _locationData.latitude, longitude: _locationData.longitude),
    //   lang: Lang.ru,
    // ));

    return true;

  }



  Future<LatLng> getGPS()async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    LatLng defPos;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        //todo no Permission
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        //todo NoPermission
        return null;
      }
    }
    _locationData = await location.getLocation();
    print("Location" + _locationData.latitude.toString());
    defPos = LatLng(_locationData.latitude, _locationData.longitude);

    print("LOCATION " +
        _locationData.latitude.toString() +
        " " +
        _locationData.longitude.toString());

    return defPos;
  }

  bool check(LatLng center, LatLng point){

      geo.LatLng _center = geo.LatLng(center.latitude, center.longitude);
      geo.LatLng _point = geo.LatLng(point.latitude, point.longitude);

      geo.Geodesy geodesy = geo.Geodesy();
      num distance = geodesy.distanceBetweenTwoGeoPoints(_center, _point);

      print(distance);
      if (distance > 200) {
        print('false');


        return false;
      } else {
        print('true');
        return true;
      }

  }

  initOrientation(){}



  close() {
    _streamController.close();
  }
}
