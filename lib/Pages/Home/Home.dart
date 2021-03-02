import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pto_photo/Pages/GoogleMapPage/GoogleMapPage.dart';
import 'package:pto_photo/Style.dart';
import 'package:pto_photo/generated/l10n.dart';
import 'package:pto_photo/Models/ItemPhoto.dart';
import 'button_add.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:camera_camera/page/camera.dart';
import 'package:pto_photo/utils/time_formatter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ItemPhoto> list = [];

  int _counter = 0;

  double h = 20;
  double H;

  initSize(){
    double pixelh = 60 / MediaQuery.of(context).devicePixelRatio ;
    print("pixelh "+pixelh.toString());
    h=pixelh;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    initSize();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          S.of(context).app_name,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.arrow_upward,
              color: Colors.blueAccent,
              size: 24,
            ),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 12,
              ),
              buttonAdd(context, onPress: () async {
                File newFile = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Camera(
                      // imageMask: Container(
                      //     height: MediaQuery.of(context).size.height,
                      //     width: MediaQuery.of(context).size.width,
                      //     child: Image.asset(
                      //       'assets/images/mask.png',
                      //       fit: BoxFit.fitWidth,
                      //     )),
                      imageMask: mask(),
                      mode: CameraMode.fullscreen,
                      enableCameraChange: false,
                    ),
                  ),
                );
                if (newFile != null) {
                  ItemPhoto step = ItemPhoto(newFile);
                  if (await step.initLocation()) {
                    list.add(step);
                    setState(() {});
                    await list[list.length - 1].updateData();
                  } else {
                    print("NO LOCATION PERMISSION");
                  }
                }
              }),
              _generatorItems()
            ],
          ),
        ),
      ),
    );
  }

  _generatorItems() {
    String _lnText(LatLng position) {
      return position.latitude.toString() +
          "\n" +
          position.longitude.toString();
    }

    if (list.length == 0) {
      return SizedBox();
    } else {
      return Column(
        children: List.generate(list.length, (index) {

        _onMapCreated(GoogleMapController controllerA) {list[index].controller = controllerA;}
          Set<Marker> _marker = {
            Marker(
                markerId: MarkerId(list[index].markerId+_counter.toString()),
                position: list[index].latLongUser == null? list[index].latLongFirst:list[index].latLongUser,
                draggable: false,
                onTap: () {})
          };
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                  color: cWhite,
                  boxShadow: shadowContainer,
                  borderRadius:
                      BorderRadius.all(Radius.circular(borderRadius))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(borderRadius)),
                          child: Container(
                            height: 180,
                            width: 180,
                            child: Image.file(
                              list[index].file,
                              fit: BoxFit.cover,
                            ),
                            // child: Container(
                            //   child: Column(
                            //     children: [
                            //       Container(
                            //         width: MediaQuery.of(context).size.width,
                            //         height: MediaQuery.of(context).size.height/2 - h/2,
                            //
                            //       ),
                            //       Row(),
                            //       Container(),
                            //     ],
                            //   ),
                            // ),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width -
                                12 * 2 -
                                (180 + 8 * 2),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: textInfo(list[index]),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      // onTap: () async {
                      //   //todo select custom point
                      //   print("tap");
                      //   LatLng result = await Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               GoogleMapPage(list[index])));
                      //   print("MAP PAGE RESULT " + result.toString());
                      //   if (result != null) {
                      //     print(result);
                      //     list[index].latLongUser = result;
                      //     _marker = {
                      //       Marker(
                      //           markerId:
                      //               MarkerId("id-${Random().nextInt(100)}"),
                      //           position: list[index].latLongUser ??
                      //               list[index].latLongFirst,
                      //           draggable: false,
                      //           onTap: () {})
                      //     };
                      //   }
                      //   setState(() {});
                      // },
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(borderRadius)),
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            onTap: (info) async {
                              print("tap");
                              LatLng result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GoogleMapPage(list[index])));
                              print("MAP PAGE RESULT " + result.toString());
                              if (result != null) {
                                _counter ++;
                                print(_counter);
                                list[index].latLongU = result;
                                _marker = {
                                  Marker(
                                      markerId: MarkerId(
                                          list[index].markerId),
                                      position: list[index].latLongUser,
                                      draggable: false,
                                      onTap: () {})
                                };

                                setState(() {});

                                print("USER VALUE "+list[index].latLongUser.toString());
                              }
                            },
                            // onMapCreated: _onMapCreated,
                            markers: _marker,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: false,
                            mapToolbarEnabled: false,
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            zoomControlsEnabled: false,


                            // markers: _markers,
                            initialCameraPosition: CameraPosition(
                              target: list[index].latLongUser ??
                                  list[index].latLongFirst,
                              zoom: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      );
    }
  }

  Widget textInfo(ItemPhoto item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).item_header,
              style: TextStyle(
                  color: cMainBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  fontFamily: fontFamily),
            ),
            Text(
              getDateRussian(item.date, context),
              style: TextStyle(
                  color: cMainBlack.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: fontFamily),
            ),
          ],
        ),
        // Text("Ш: " + ((item.latLongUser == null)?item.latLongFirst.latitude.toString():item.latLongUser.latitude.toString()),
        //   style: TextStyle(color: cMainBlack. withOpacity(0.9), fontWeight: FontWeight.w400 , fontSize: 14, fontFamily: fontFamily),),
        // Text("Д: " + ((item.latLongUser == null)?item.latLongFirst.longitude.toString():item.latLongUser.longitude.toString()),
        //   style: TextStyle(color: cMainBlack. withOpacity(0.9), fontWeight: FontWeight.w400 , fontSize: 14, fontFamily: fontFamily),),
        Text(
          item.address ?? "Ожидание аадреса",
          style: TextStyle(
              color: cMainBlack.withOpacity(0.9),
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: fontFamily),
        ),
      ],
    );
  }



  Widget mask (){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            decoration: BoxDecoration(
                border: Border.symmetric(vertical: BorderSide(color: Colors.white, width: 2)),
               // borderRadius: BorderRadius.all(Radius.circular(6))
            ),
            width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width/4),
            height: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width/4))*0.8 ,
            child: Center(
              child: Padding(
                padding:  EdgeInsets.only(top: h*3.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                  width: h*3.5,
                  height: h,


                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}