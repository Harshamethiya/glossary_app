import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glossary_app/pages/Home.dart';
import 'package:glossary_app/pages/LoginPage.dart';
import 'package:uuid/uuid.dart';


import 'models/UserModel.dart';
import 'models/firebasehelper.dart';
var uuid=Uuid();
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentuser=FirebaseAuth.instance.currentUser;

  if(currentuser!=null)
  {
    UserModel? usermodel=await firebasehelper.getusermodel(currentuser.uid);
    if(usermodel!=null){
      runApp(MyAppLogin(firebaseUser: currentuser, usermodel: usermodel));
    }else{
      runApp(const MyApp());
    }

  }
  else{
    runApp(const MyApp());
  }


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,


        home: LoginPage()
    );
  }
}
class MyAppLogin extends StatelessWidget {
  final User firebaseUser;
  final UserModel usermodel;

  const MyAppLogin({super.key, required this.firebaseUser, required this.usermodel});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,


        home: Homepage(usermodel: usermodel, firebaseUser: firebaseUser)
    );
  }
}

