// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_string_escapes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mega_project/new_pass_page.dart';
import 'package:mega_project/new_pass_page3.dart';
import 'auth_controller.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'singup_page.dart';
import 'package:path/path.dart';

class Newpass2 extends StatefulWidget {
  final String userId;

  const Newpass2({super.key, required this.userId});

  @override
  State<Newpass2> createState() => Newpass2State();
}

TextEditingController dateController = TextEditingController();

class Newpass2State extends State<Newpass2> {
  XFile? image, bonafide;

  final ImagePicker picker = ImagePicker();
  final ImagePicker picker2 = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  Future getBonafide(ImageSource media) async {
    var bona = await picker2.pickImage(source: media);

    setState(() {
      bonafide = bona;
    });
  }

  Future uploadImageToFirebase() async {
    // Create a reference to the location where we want to store the image
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images/${DateTime.now().millisecondsSinceEpoch}");
    Reference ref2 = FirebaseStorage.instance
        .ref()
        .child("images/${DateTime.now().millisecondsSinceEpoch}");

    // Get the file from the XFile object
    File file = File(image!.path);
    File file2 = File(bonafide!.path);

    // Upload the file to Firebase Storage
    TaskSnapshot taskSnapshot = await ref.putFile(file);
    TaskSnapshot taskSnapshot2 = await ref2.putFile(file2);

    // Get the download URL of the uploaded image
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    String bonafideUrl = await taskSnapshot2.ref.getDownloadURL();

    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('Info').doc(widget.userId);

// Update the document with the image URLs
    await userDocRef.update({
      'imageUrl': imageUrl,
      'bonafideUrl': bonafideUrl,
    });

    // Use the imageUrl as needed, such as adding it to a Firebase document
    // using the Firebase Firestore plugin.
    // Example:
    // await FirebaseFirestore.instance.collection('users').doc('user1').update({'profileImageUrl': imageUrl});

    // Print the imageUrl to the console
    print('Image URL: $imageUrl');
    print('Bonafide URL: $bonafideUrl');
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void myAlert2() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getBonafide(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getBonafide(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Upload Image')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(height: 160),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      myAlert();
                    },
                    child: Text('Upload your Photo'),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                //if image not null show the image
                //if image null show text
                image != null
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 35, top: 15, right: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(image!.path),
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 65),
                        child: Text(
                          "No Image",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
              ],
            ),
            Row(
              children: [
                SizedBox(height: 160),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SizedBox(
                    width: 145,
                    child: ElevatedButton(
                      onPressed: () {
                        myAlert2();
                      },
                      child: Text('Upload Bonafid'),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                //if image not null show the image
                //if image null show text
                bonafide != null
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 35, top: 15, right: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(bonafide!.path),
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 65),
                        child: Text(
                          "No Image",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
              ],
            ),
            SizedBox(
              height: 95,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 50,
                    width: 170,
                    child: OutlinedButton.icon(
                        onPressed: () {
                          // AuthController.instance.logOut();
                          // Respond to button press
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Newpass(email: "")));
                        },
                        icon: Icon(Icons.keyboard_backspace_rounded, size: 30),
                        label: Text("back"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red))),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 50,
                    width: 170,
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            // Respond to button press
                            uploadImageToFirebase();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Newpass3(userId: widget.userId)));
                          },
                          icon: Icon(Icons.arrow_back_rounded, size: 25),
                          label: Text("Next"),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(color: Colors.red)),
                              ))),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
