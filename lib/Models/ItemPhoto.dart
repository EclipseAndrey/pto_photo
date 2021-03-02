import 'dart:io';
import 'dart:math';
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'dart:typed_data';

import 'package:yandex_geocoder/yandex_geocoder.dart';

const String ya_key = "3980e55c-3d0b-4c4e-a3f2-0ea6db1984d7";

class ItemPhoto {
  File file;
  LatLng latLongFirst;
  LatLng latLongUser;
  File _fileOut;
  bool setData;
  bool _initLocation;
  DateTime date;
  String address;
  String markerId ;
  GoogleMapController controller;

  ItemPhoto(this.file, {this.latLongFirst, this.latLongUser}){
    setData = false;
    _initLocation = false;
    date = DateTime.now();
    markerId = "id-${Random().nextInt(100)}";
  }

  File get fileOut => _fileOut;


  updateData()async{
    Uint8List data  = await file.readAsBytes();
    FlutterExif exif = FlutterExif.fromPath(file.path);
    await exif.setLatLong( ((latLongUser == null)?(latLongFirst.latitude):(latLongUser.latitude)),((latLongUser == null)?(latLongFirst.longitude):(latLongUser.longitude)));
    await exif.saveAttributes();
    _fileOut = File.fromRawPath(data);
    GallerySaver.saveImage(
      _fileOut.path,
    ).then((value) => {print("file save " + value.toString())});
  }

  set latLongU(LatLng latLng) {
    latLongUser = latLng;
    markerId = "id-${Random().nextInt(100)}";
  }



  Future<bool>initLocation()async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    _locationData = await location.getLocation();
    print("Location" + _locationData.latitude.toString());
    latLongFirst = LatLng(_locationData.latitude, _locationData.longitude);
    _initLocation = true;
    print("LOCATION " + _locationData.latitude.toString() + " " + _locationData.longitude.toString());

    YandexGeocoder geocoder = YandexGeocoder(apiKey: ya_key);
    GeocodeResponse geocodeFromPoint = await geocoder.getGeocode(GeocodeRequest(
      geocode: PointGeocode(latitude: _locationData.latitude, longitude: _locationData.longitude),
      lang: Lang.ru,
    ));

    print("YANDEX geocoder ==========================="+geocodeFromPoint.response.toString());
    address = geocodeFromPoint.firstAddress.formatted;



    return true;

  }



}