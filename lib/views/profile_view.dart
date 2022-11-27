import 'package:animate_do/animate_do.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../services/auth/auth_service.dart';
import '../utilities/show_dialog_messages.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String get userEmail => AuthService.firebase().currentUser!.email;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /*  File? _photo;
  String imageUrl = '';
  final ImagePicker _picker = ImagePicker();

  String getImageFromMail(String userPhoto) {
    if (userPhoto == null) {
      return '';
    } else {
      return userPhoto;
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  void imgRemove() {
    setState(() {
      _photo = null;
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    const destination = 'images';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(_photo!);

      await ref.getDownloadURL().then((value) => {imageUrl = value});
    } catch (e) {
      print('error occured');
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 95, 81, 223),
        appBar: AppBar(
          title: const Text("Profile"),
          titleSpacing: 20,
          backgroundColor: const Color.fromARGB(255, 95, 81, 223),
          elevation: 0,
        ),
        body: FadeIn(
          duration: const Duration(seconds: 1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 90,
                ),
                const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.person,
                    size: 130,
                    color: Colors.white,
                  ),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          //side: BorderSide(color: Colors.deepOrange),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      final wantsToLogout = await showLogoutMessage(context);

                      if (wantsToLogout) {
                        await AuthService.firebase().logOut();

                        if (!mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      "Log out",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
