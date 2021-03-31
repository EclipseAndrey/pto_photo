bool checkDouble(String s) {
  var stroka1 = RegExp("^([0-9]+),([0-9]+)\$");
  var stroka2 = RegExp("^([0-9]+)\$");
  return (dotCheck(s) || stroka1.hasMatch(s) || stroka2.hasMatch(s));
}

bool dotCheck (String s){
  try{
    double.parse(s);
    return true;
  }catch(e){
    return false;
  }

}


double initDoubleReplace(String s){
  var stroka1 = RegExp("^([0-9]+),([0-9]+)\\\$");
  var stroka2 = RegExp("^([0-9]+)\\\$");

  if(dotCheck(s)){
    s = s.replaceFirst(RegExp(','), '.');
    return double.parse(s);
  }else if(stroka1.hasMatch(s)){
    print("=="+s);
    s = s.replaceFirst(RegExp(','), '.');
    print("=="+s);
    return double.parse(s);
  }else if(stroka2.hasMatch(s) ) {
    return int.parse(s).toDouble();
  }
  return 0.0;
}