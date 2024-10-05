import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glossary_app/pages/LoginPage.dart';


import '../models/UserModel.dart';
import 'AddProduct.dart';
class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  TextEditingController emailcon = TextEditingController();
  TextEditingController passcon = TextEditingController();
  TextEditingController cpasscon = TextEditingController();
  void checkvalue (){
    String email= emailcon.text.trim();
    String pass= passcon.text.trim();
    String cpass= cpasscon.text.trim();
    if(email=="" || pass==""|| cpass=="")
    {
      Fluttertoast.showToast(msg: 'Please Fill All The  Fields');
      //print('Please Fill All The  Fields');
      // AlertDialog(semanticLabel: 'Please Fill All The  Fields');
    }else if(pass!=cpass){
      Fluttertoast.showToast(msg: 'Password not match');
      //print('Password not match');
      //  AlertDialog(semanticLabel: 'Password not match');
    }
    else{
      signup(email, pass);
    }

  }
  void signup(String email,String pass)async{
    UserCredential? usercredential;
    try{
      usercredential= await FirebaseAuth.instance.createUserWithEmailAndPassword
        (email: email, password: pass);
    }on FirebaseAuthException catch(e){
      Fluttertoast.showToast(msg:(e.code.toString()));
      //print(e.code.toString());
    }
    if(usercredential != null)
    {
      String uid=usercredential.user!.uid;
      UserModel usermodel=UserModel(uid:uid,

          email:email,
          );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(usermodel.toMap()).then((value) => print("New User Created"),);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>LoginPage(),)
      );


    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondary,
        centerTitle: true,
        title: Text("Sign Up"),
      ),
      body:SafeArea(
        child:  Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 30
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                   Text("Glossary App",style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: emailcon,

                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(25)),

                        ),
                        labelText: "Enter Email"

                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller:passcon,
                    obscureText: true,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(25)),

                        ),
                        labelText: "Enter Password"

                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: cpasscon,
                    obscureText: true,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(25)),

                        ),
                        labelText: "Conform Password"

                    ),
                  ),
                  const SizedBox(height: 20,),
                  CupertinoButton(
                      child: const Text("Sign In"),
                      color:Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      onPressed: (){
                        checkvalue();
                        // Navigator.push(context, MaterialPageRoute(builder: (context){return Completeprofile();}));
                      }),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Row(
                        children: [
                          const Text("Already have an account?",style: TextStyle(fontSize: 16),),
                          CupertinoButton(

                              child: const Text("Login",style: TextStyle(fontSize: 16)),
                              // color: Theme.of(context).colorScheme.secondary,
                              onPressed: (){

                                Navigator.pop(context);
                              })]),
                  )
                ],

              ),
            ),
          ),
        ),
      ),



    );
  }
}
