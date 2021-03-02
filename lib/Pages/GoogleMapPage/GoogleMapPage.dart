import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geodesy/geodesy.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pto_photo/Models/ItemPhoto.dart';
import 'package:pto_photo/Style.dart';

const String key = "AIzaSyAEBsJIE-UAlDTLpYBKbbshsew12e_vquw";

class GoogleMapPage extends StatefulWidget {

  ItemPhoto center;

  GoogleMapPage(this.center);
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  LatLng _currentPosition ;
  Set<Marker> _markers = {};

  int count = 0;
  _onMapCreated(GoogleMapController controller) {

    print("User init ${widget.center.latLongUser.toString()} ++ ${(widget.center.latLongUser == null?widget.center.latLongFirst:widget.center.latLongUser).toString()}");
    _markers = {};
      _markers.add(
        Marker(
          markerId: MarkerId("id-$count"),
          position: widget.center.latLongUser == null?widget.center.latLongFirst:widget.center.latLongUser,
          draggable: true,
          onDragEnd: (point){
            if(!check(widget.center.latLongFirst, point)){
              //todo setPosition widget.center
              _onMapCreated(controller);
            }
          }
        ),
      );
      setState(() {});
      count++;

  }

  bool check(LatLng center, LatLng point){
    geo.LatLng _center = geo.LatLng(center.latitude,center.longitude);
    geo.LatLng _point = geo.LatLng(point.latitude,point.longitude);

    geo.Geodesy geodesy = geo.Geodesy();
    num distance = geodesy.distanceBetweenTwoGeoPoints(_center, _point);

    print(distance);
    if(distance > 200){
      print('false');
      Fluttertoast.showToast(
          msg: "Допустимый радиус - 200м",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return false;
    }else{
      _currentPosition = point;
      print('true');
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.center.latLongUser == null?widget.center.latLongFirst:widget.center.latLongUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: cWhite,
        centerTitle: true,
        title: Text("Удерживайте маркер для перемещения", style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),),
        leading: GestureDetector(
          onTap:(){
            Navigator.pop(context, _currentPosition);
          },
          behavior: HitTestBehavior.deferToChild,
          child: Container(
            child: Icon(Icons.save, color: cButtons,),
          ),
        ),
      ),
      body: GoogleMap(

        onMapCreated: _onMapCreated,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: widget.center.latLongUser == null?widget.center.latLongFirst:widget.center.latLongUser,
          zoom: 15,
        ),
      ),
    );
  }
}
