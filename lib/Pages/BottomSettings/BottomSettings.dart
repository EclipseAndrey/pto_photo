import 'dart:convert';

import 'package:geodesy/geodesy.dart' as geo;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pto_photo/Const.dart';
import 'package:pto_photo/Models/ItemPhoto.dart';
import 'package:pto_photo/Pages/GoogleMapPage/GoogleMapPage.dart';
import 'package:pto_photo/Style.dart';
import 'package:pto_photo/utils/checkDouble.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<bool> showSettings(BuildContext context,)async{

  await showBarModalBottomSheet(
    context: context, builder: (context,data) =>SettingsContent(),
  );
}

class SettingsContent extends StatefulWidget {




  @override
  _SettingsContentState createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  bool auto = true;

  String sub;

  TextEditingController controllerLat = TextEditingController();
  TextEditingController controllerLng = TextEditingController();

  initStatus()async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool(statusPosition)??true){
      auto = true;
    }else{
      auto = false;
    }
    LatLng l = LatLng.fromJson(json.decode(prefs.getString(defaultPosition)));
    sub = l.toString();
    controllerLng.text = l.longitude.toString();
    controllerLat.text = l.latitude.toString();

    setState(() {

    });
  }

  setStatus(bool status)async{
    if(status != auto) {
      auto = status;
      setState(() {

      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(statusPosition, status);
    }
  }

  Future<bool>setMainPosition()async{
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

    ItemPhoto step = ItemPhoto(null)..latLongFirst = defPos;
    LatLng result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => GoogleMapPage(step, chk: false,)));

    print(result);

    if(result != null){
      final prefs = await SharedPreferences.getInstance();

      print(result);

      prefs.setString(defaultPosition, json.encode(result.toJson()));
      sub = result.toString();
      controllerLng.text = result.longitude.toString();
      controllerLat.text =  result.latitude.toString();
      setState(() {

      });
      return true;
    }

    return false;

  }

  @override
  void initState() {
    super.initState();
    initStatus();

    controllerLat.addListener(() {
      if(controllerLat.text != null && controllerLng.text != null){
        setStringPosition(controllerLat.text, controllerLng.text);
      }
    });
    controllerLng.addListener(() {
      if(controllerLat.text != null && controllerLng.text != null){
        setStringPosition(controllerLat.text, controllerLng.text);
      }
    });
  }

  setStringPosition(String latitude, String longitude)async{
    final prefs = await SharedPreferences.getInstance();
    if(checkDouble(latitude) && checkDouble(longitude)){
      double lng = initDoubleReplace(longitude);
      double lat = initDoubleReplace(latitude);
      prefs.setString(defaultPosition, json.encode(LatLng(lat, lng).toJson()));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height*0.95,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              SizedBox(height: 18,),
              _buttonAuto(),
              SizedBox(height: 18,),
              _buttonManually(),
              auto == true?SizedBox():Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _inputLatLng(),
              )


            ],
          ),
        ),
      ),
    );
  }

  _buttonAuto(){
    return ListTile(
      onTap: (){

        setStatus(true);
      },
      title: Text("Определять автоматически"),
      trailing: Icon(auto?Icons.check_circle:Icons.check_circle_outline, size: 24, color: cBlue,),
    );
  }

  _buttonManually(){
    return ListTile(
      onTap: ()async{
        setStatus(false);
      },
      title: Text("Вручную"),
      trailing: Icon(!auto?Icons.check_circle:Icons.check_circle_outline, size: 24, color: cBlue,),
      subtitle: sub == null?null:Text(sub),
    );
  }

  Widget _inputLatLng(){
    return Column(
      children: [
        ListTile(
          onTap: ()async{
            if (await setMainPosition()) {
            setStatus(false);
            }
          },
          title:  Text("Выбрать на карте", style: TextStyle(color: cBlue),),
        ),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("или"),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: cBlue)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: controllerLat,
                    decoration: InputDecoration(

                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(153, 155, 158, 1),
                      ),
                      hintText: "",
                    ),
                    style: TextStyle(
                        color: Color.fromRGBO(47, 82, 127, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamily),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    border: Border.all(color: cBlue)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: controllerLng,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(153, 155, 158, 1),
                      ),
                      hintText: "",
                    ),
                    style: TextStyle(
                        color: Color.fromRGBO(47, 82, 127, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamily),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }



}


class Podborka{
List<PodborkaItem> items;

}


class PodborkaItem{}