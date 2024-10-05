import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glossary_app/pages/AddProduct.dart';



import '../models/UserModel.dart';

class Homepage extends StatefulWidget {

  final UserModel usermodel;
  final User firebaseUser;

  const Homepage({super.key, required this.usermodel, required this.firebaseUser});


  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
      leading:IconButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct( firebaseUser: widget.firebaseUser, usermodel: widget.usermodel,)));
      },
          icon: Icon(Icons.add_a_photo,color: Colors.orange,)),
       // automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondary,
        centerTitle: true,
        title: Text("HomePage"),
      ),
      body: SafeArea(child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            StreamBuilder(stream: FirebaseFirestore.instance.collection('products').snapshots(), builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView.builder(itemBuilder: (context, index) {
                  return Expanded(
                    flex: 3,
                      child: SingleChildScrollView(
                        child: Card(
                         elevation: 20,
                          child: Column(
                            children: [
                              Image.network("${snapshot.data!.docs[index]['itemimage']}",width: 150,height: 150,),
                              SizedBox(height: 8,),
                              Text("${snapshot.data!.docs[index]["itemname"]}")
                              //NetworkImage('${snapshot.data.docs[index]['itemimage']}'),
                            ],
                          ),
                        ),
                      ),

                  );

                },
                itemCount: snapshot.data!.docs.length,
                );

              }
              else{
                return Text('${snapshot.hasError.toString()}');
              }
            },)
          ),
      )),


    );
  }
}
