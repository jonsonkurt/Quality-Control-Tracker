import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
import 'package:quality_control_tracker/permission_controller.dart';

class InspectorProfileController with ChangeNotifier {
  final picker = ImagePicker();

  String? userID = FirebaseAuth.instance.currentUser?.uid;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  XFile? _image;
  XFile? get image => _image;
  String imgURL = '';

  Future pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      notifyListeners();
      // ignore: use_build_context_synchronously
      // updloadImage(context);
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      notifyListeners();
      // ignore: use_build_context_synchronously
      // updloadImage(context);
    }
  }

  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        if (await Permission.camera.request().isGranted) {
                          // ignore: use_build_context_synchronously
                          pickCameraImage(context);
                        } else {
                          await cameraPermission();
                        }

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      leading: const Icon(
                        Icons.camera,
                        color: Color.fromARGB(255, 35, 35, 35),
                      ),
                      title: const Text('Camera'),
                    ),
                    ListTile(
                      onTap: () async {
                        bool request =
                            await requestPermission(Permission.storage);
                        if (request) {
                          // ignore: use_build_context_synchronously
                          pickGalleryImage(context);
                        }

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      leading: const Icon(
                        Icons.image,
                        color: Color.fromARGB(255, 35, 35, 35),
                      ),
                      title: const Text('Gallery'),
                    ),
                  ],
                )),
          );
        });
  }

  updloadImage() async {
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref('inspectorsProfile/$userID');
    if (image != null) {
      firebase_storage.UploadTask uploadTask =
          storageRef.putFile(File(image!.path).absolute);
      await Future.value(uploadTask);
      imgURL = await storageRef.getDownloadURL();
    }
  }
}
