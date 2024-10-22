import 'package:flutter/material.dart';
import 'package:urlshortner/Screens/Login.dart';
import 'package:urlshortner/Screens/SignUp.dart';
class Loginorsignup extends StatefulWidget {
  const Loginorsignup({super.key});

  @override
  State<Loginorsignup> createState() => _LoginorsignupState();
}

class _LoginorsignupState extends State<Loginorsignup> {
  bool isLogin=true;
  void toggle(){
    setState(() {
      isLogin=!isLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isLogin){
      return Login(onPressed: toggle,);
    }
    else
      {
        return SignUp(onPressed: toggle,);
      }

  }
}
