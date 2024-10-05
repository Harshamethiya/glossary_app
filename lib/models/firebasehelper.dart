import 'package:cloud_firestore/cloud_firestore.dart';

import 'UserModel.dart';


class firebasehelper {

  static Future<UserModel?> getusermodel(String uid)async{
    UserModel? usermodel;
    DocumentSnapshot docsnap=await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if(docsnap.data()!=null)
    {
      usermodel = UserModel.fromMap(docsnap.data() as Map<String,dynamic>);
    }
    return usermodel;
  }
}