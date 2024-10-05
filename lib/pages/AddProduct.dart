import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glossary_app/main.dart';
import 'package:glossary_app/models/productmodel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../models/UserModel.dart';
import 'Home.dart';

class AddProduct extends StatefulWidget {
  final UserModel usermodel;
  final User firebaseUser;

  const AddProduct({super.key, required this.usermodel, required this.firebaseUser});


  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? imagefile;

  TextEditingController fulllname_controller = TextEditingController();

  void imagecropper(XFile? file) async {
    var cropimage = await ImageCropper().cropImage(
        sourcePath: file!.path,
      //  aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1,),
        compressQuality: 10
    );
    if (cropimage != null) {
      setState(() {
        imagefile = File(cropimage.path);
      });
    }
    // CroppedFile? cropimage=await ImageCropper.cropImage(sourcePath: file.path);
  }

  void selectimage(ImageSource imagesource) async {
    XFile? pickfile = await ImagePicker().pickImage(source: imagesource);
    if (pickfile != null) {
      imagecropper(pickfile);
    }
  }

  void photooption() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                selectimage(ImageSource.gallery);
              },
              leading: Icon(Icons.photo_album),
              title: Text("Select from Gallery"),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                selectimage(ImageSource.camera);
              },
              leading: Icon(Icons.photo_camera),
              title: Text("Select from Camera"),
            )
          ],
        ),
      );
    });
  }

  void checkvalue() {
    String fullname = fulllname_controller.text.trim();
    if (fullname == "" || imagefile == "") {
      Fluttertoast.showToast(msg:'Please enter all the fields' );
      //print('Please enter all the fields');
    }
    else {
      uploaddata();
    }
  }

  void uploaddata() async {
    var uid=uuid.v1();
    UploadTask uploadtask = FirebaseStorage.instance.ref("products").child(uid).putFile(imagefile as File);
    TaskSnapshot snapshot = await uploadtask;
    String imageUrl =await snapshot.ref.getDownloadURL();
    String fullname=fulllname_controller.text.trim();
    productmodel product=productmodel(uid, imageUrl, fullname);
    await FirebaseFirestore.instance.collection("products").doc(product.uid).set(product.toMap());
    Navigator.push(context, MaterialPageRoute(
      builder: (context) =>
          Homepage(usermodel: widget.usermodel, firebaseUser: widget.firebaseUser) ,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondary,
        centerTitle: true,
        title: Text("Add Products"),
      ),
      body: SafeArea(
          child: Container(

            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 40
              ),
              child: ListView(
                children: [
                  SizedBox(height: 20,),
                  
                  Container(
                    child:
                    Expanded(child:(imagefile != null) ? Image(image:FileImage(imagefile!)) : Image.asset('assets/images/glosary.jpeg')
                    )//Image(image: FileImage(
                        //imagefile!)),
                  ),

                   SizedBox(height: 20,),
                  TextField(
                    controller: fulllname_controller,

                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(25)),

                        ),
                        labelText: "Enter Product Name"

                    ),
                  ),
                  SizedBox(height: 20,),
                  CupertinoButton(
                      child: const Text("Add Image"),
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      onPressed: () {
                      photooption();                      }),
                  SizedBox(height: 20,),
                  CupertinoButton(
                      child: const Text("Submit"),
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      onPressed: () {checkvalue();
                         }),
                ],
              ),
            ),
          )
      ),
    );
  }
}