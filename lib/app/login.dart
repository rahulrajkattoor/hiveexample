import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveexample/app/Database/database.dart';
import 'package:hiveexample/app/home.dart';
import 'package:hiveexample/app/registration.dart';

import 'model/usermodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.openBox<User>('user');
  runApp(GetMaterialApp(
    home: login(),
    debugShowCheckedModeBanner: false,
  ));
}

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController uname = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login page"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 60, right: 60),
            child: TextField(
              controller: uname,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_sharp),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "username"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 60, right: 60),
            child: TextField(
              controller: pass,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_sharp),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "password"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 150, right: 150),
            child: ElevatedButton(
                onPressed: () async {
                  final userList = await DBFuction.instance.getUser();
                  findUser(userList);
                },
                child: Text("login")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(onPressed: () {
              Get.offAll(registration());
            }, child: Text("register")),
          )
        ],
      ),
    );
  }

  Future<void> findUser(List<User> userList) async {
    final email = uname.text.trim();
    final password = pass.text.trim();
    bool userFound = false;
    final validate = await ValidateLogin(email, password);
    if (validate == true) {
      await Future.forEach(userList, (user) {
        if (user.email == email && user.password == password) {
          userFound = true;
        } else {
          userFound = false;
        }
      });
      if (userFound == true) {
        Get.offAll(() => home(email: email));
        Get.snackbar("succes", "Login succes", backgroundColor: Colors.green);
      } else {
        Get.snackbar("Error", "incorrect email/password",
            backgroundColor: Colors.red);
      }
    }
  }

  Future<bool> ValidateLogin(String email, String password) async {
    if (email != '' && password != '') {
      return true;
    } else {
      Get.snackbar("Error", "Fields can not be empty",
          backgroundColor: Colors.red);
      return false;
    }
  }
}
