

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveexample/app/model/usermodel.dart';

class DBFuction {
  DBFuction.internal();
  static DBFuction instance=DBFuction.internal();
   factory DBFuction(){
     return instance;
   }
   Future<void>userSignup(User user)async{
   final db=await Hive.openBox<User>('users');
   db.put(user.id,user);
   }
   Future<List<User>>getUser()async{
     final db=await Hive.openBox<User>('users');
     return db.values.toList();
   }

}