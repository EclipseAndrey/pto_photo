import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

Widget buttonAdd(BuildContext context, {Function onPress}){
  double w = MediaQuery.of(context).size.width-24;
  double h = 200;

  return GestureDetector(
    behavior: HitTestBehavior.deferToChild,
    onTap: onPress??null,
    child: DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(12),
      // padding: EdgeInsets.all(12),
      dashPattern: [12],
      color: Colors.black.withOpacity(0.7),
      child: Container(
        height: h-6,
        width: w-6,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //getIconSvg(id: 13, color: cIcons),
              Icon(Icons.add, color: Colors.blueAccent, size: 30,),
              Text("Добавить фото", style: TextStyle(color: Colors.blueAccent, fontStyle: FontStyle.normal, fontWeight: FontWeight.w400),),
            ],
          ),
        ),
      ),
    ),
  );
}