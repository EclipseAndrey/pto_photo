import 'package:flutter/material.dart';
import 'package:pto_photo/Pages/Home/Home.dart';
import 'package:pto_photo/Style.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool singInb = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: Content(),
    );
  }

  String singIn = "Войти", singUp = "Создать аккаунт";




  Widget Content(){
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(singInb?"Вход":"Регистрация", textAlign: TextAlign.center, style: TextStyle(color: cBlue, fontSize: 22, fontFamily: fontFamily,fontWeight: FontWeight.w600),),
                SizedBox(height: 18,),
                SizedBox(height: 18,),
                fieldEmail(),
                SizedBox(height: 18,),
                fieldPass(),
                SizedBox(height: 18,),

                singInb?SizedBox():fieldPass(text: "Повторите пароль"),
                SizedBox(height: 18,),

                _buttonSave(),
                haveAccount()
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget fieldEmail(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("E-mail", style: TextStyle(color: cDefault, fontFamily: fontFamily , fontSize: 16),),
        TextField(
          decoration: InputDecoration(
            // border: InputBorder,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(153, 155, 158, 1),
            ),
            hintText: "example@gmail.com",
          ),
          style: TextStyle(
              color: Color.fromRGBO(47, 82, 127, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamily
          ),

        ),
      ],
    );
  }
  Widget fieldPass({String text}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text??"Пароль", style: TextStyle(color: cDefault, fontFamily: fontFamily , fontSize: 16),),
        TextField(
          decoration: InputDecoration(
            // border: InputBorder,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(153, 155, 158, 1),
            ),
            hintText: "Ваш пароль",
          ),
          style: TextStyle(
              color: Color.fromRGBO(47, 82, 127, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamily
          ),

        ),
      ],
    );
  }



  _buttonSave(){
    return InkWell(
      onTap: ()async{
        //todo
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
      },
      child: Container(
        decoration: BoxDecoration(
            color: cBlue,
            borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(singInb?singIn:singUp, style: TextStyle(
              color: cWhite, fontWeight: FontWeight.w500, fontSize: 18, fontFamily: fontFamily

          ),),
        ),
      ),
    );
  }


  haveAccount(){
    return GestureDetector(
      onTap: (){
        singInb = !singInb;
        setState(() {

        });
      },
      behavior: HitTestBehavior.deferToChild,
      child: Text(singInb?"Нет аккаунта?":"Уже есть аккаунт?",  style: TextStyle(color: cBlue, fontSize: 14, fontFamily: fontFamily,fontWeight: FontWeight.w600),),
    );
  }
}
