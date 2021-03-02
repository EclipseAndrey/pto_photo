import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pto_photo/generated/l10n.dart';

String setDBTime(DateTime date) {
  String ye, mo, da, ho, mi;
  ye = date.year.toString();
  mo = date.month < 10 ? "0" + date.month.toString() : date.month.toString();
  da = date.day < 10 ? "0" + date.day.toString() : date.day.toString();
  ho = date.hour < 10 ? "0" + date.hour.toString() : date.hour.toString();
  mi = date.minute % 60 < 10
      ? "0" + (date.minute % 60).toString()
      : (date.minute % 60).toString();
  return  ye + "." + mo + "." + da + " " + ho + ":" + mi;
}

DateTime fromDBTime (String time){
  return DateFormat("yyyy.MM.dd HH:mm").parse(time);
}


String getDateRussian(DateTime date, BuildContext context){

  String hm (DateTime time){
    String  ho, mi;
    ho = date.hour < 10 ? "0" + date.hour.toString() : date.hour.toString();
    mi = date.minute % 60 < 10
        ? "0" + (date.minute % 60).toString()
        : (date.minute % 60).toString();
    return   ho + ":" + mi;
  }


  if(date.difference(DateTime.now()).inDays.abs() < 2){
    if(date.weekday == DateTime.now().weekday){
      return S.of(context).today + " " + hm(date);
    }else{
      if(date.weekday+1 == DateTime.now().weekday){
        return S.of(context).yesterday + " "+ hm(date);
      }else{
        return S.of(context).tomorrow + " " + hm(date);
      }
    }
  }else{
    return dayWeek(date.weekday) +" "+date.day.toString()+ " "+ month(date.month) + ((date.year != DateTime.now().year)?(" "+ date.year.toString()):"");
  }
}


String month(int month) {
  switch (month) {
    case 1:
      return "Января";
      break;
    case 2:
      return "Февраля";
      break;
    case 3:
      return "Марта";
      break;
    case 4:
      return "Апреля";
      break;
    case 5:
      return "Мая";
      break;
    case 6:
      return "Июня";
      break;
    case 7:
      return "Июля";
      break;
    case 8:
      return "Августа";
      break;
    case 9:
      return "Сентября";
      break;
    case 10:
      return "Октября";
      break;
    case 11:
      return "Ноября";
      break;
    case 12:
      return "Декабря";
      break;
  }
}


String dayWeek (int dayWeek){
  switch(dayWeek -1){
    case 6:{
      return "Воскресенье";
    }
    case 0:{
      return "Понедельник";
    }
    case 1:{
      return "Вторник";
    }
    case 2:{
      return "Среда";
    }
    case 3:{
      return "Четверг";
    }
    case 4:{
      return "Пятница";
    }
    case 5:{
      return "Суббота";
    }

  }
}