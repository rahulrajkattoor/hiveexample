import 'dart:js_interop';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hiveexample/app/login.dart';

import 'Database/database.dart';
import 'model/usermodel.dart';

class registration extends StatelessWidget{
  TextEditingController password=TextEditingController();

  TextEditingController username=TextEditingController();

  TextEditingController confirmpass=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("registration page"),),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100,left: 60,right: 60),
            child: TextField(
              controller: username,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_sharp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  hintText: "username"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50,left: 60,right: 60),
            child: TextField(
              controller: password,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  hintText: "password"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50,left: 60,right: 60),
            child: TextField(
              controller: confirmpass,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  hintText: "confirmpassword"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30,left: 150,right: 150),
            child: ElevatedButton(

                onPressed: (){
                  Get.offAll(login());
                  validateSignup();
                }, child: Text("registration")),
          )
        ],
      ),
    );
  }
  void validateSignup()async{
    final email=username.text.trim();
   final pass=password.text.trim();
    final cpass=confirmpass.text.trim();

    final emailValidationResult=EmailValidator.validate(email);

    if(email != "" && pass != "" && cpass != ""){
      if(emailValidationResult ==true){
        final passValidationResult = checkPassword(pass,cpass);
        if(passValidationResult ==true){
          final user=User(email:email,password:pass);
          await DBFuction.instance.userSignup(user);
          Get.back();
          Get.snackbar("sucesses","Account created");

        }


      }
      else{
        Get.snackbar("Error","provide a valid mail");
      }

    }
    else{
      Get.snackbar("Error","Field can not be empty ");

    }
  }
  bool checkPassword(String pass,String cpass){
    if(pass==cpass){
      if(pass.length<6){
        Get.snackbar("Error","password length should be >6");
        return false;
      }else{
        return true;
      }
    }else{
      Get.snackbar('Error','password mismatch');
      return false;
    }
  }
}