import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../main_tab/main_tab_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String name = "";
  String email = "";
  String lastName = "";
  String password = "";
  String confirmPassword = "";

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  final GlobalKey<FormState> _formkeysignup = GlobalKey<FormState>();

  Future<void> register() async {
    if (txtFirstName.text.isEmpty ||
        txtLastName.text.isEmpty ||
        txtEmail.text.isEmpty ||
        txtPassword.text.isEmpty ||
        txtConfirmPassword.text.isEmpty) {
      showSnackBar(
        context,
        "Please fill in all fields...!",
      );
      return;
    }
    if (txtPassword.text != txtConfirmPassword.text) {
      showSnackBar(context, "Passwords do not match");
      return; // Exit the function if passwords don't match
    }

    try {
      setState(() {
        isLoading = true;
      });

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(password: password, email: email);

             await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'name': name,
      'last_name': lastName,
      'email': email,
      // Add other user details if needed
    });


      // Upload image to Firebase Storage
      if (image != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(
                '${userCredential.user!.uid}.jpg'); // Use user's UID for unique file naming

        await ref.putFile(File(image!.path));

        // Get download URL
        String imageUrl = await ref.getDownloadURL();

        // Save user details including name, email, and profile image URL to Firestore
       await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({'profile_image': imageUrl});
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            backgroundColor: TColor.primary1,
            content: const Text(
              "Registered Successfully",
              style: TextStyle(
                fontSize: 20,
              ),
            ))));
      }
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainTabView()));
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'weak-password':
          if (context.mounted) {
            showSnackBar(context, "Password provided is too weak");
          }
          break;
        case 'email-already-in-use':
          if (context.mounted) {
            showSnackBar(context, "Account already exists!");
          }
          break;
        case 'invalid-email':
          if (context.mounted) {
            showSnackBar(context, " email address is not valid.");
          }
          break;
        case 'operation-not-allowed':
          if (context.mounted) {
            showSnackBar(context,
                "Enable email/password accounts in the Firebase Console, under the Auth tab.");
          }

        default:
          // Handle other FirebaseException codes here
          break;
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/img/back_btn.png",
                  width: 13,
                  height: 13,
                  color: TColor.subtext,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "BACK",
                  style: TextStyle(
                      color: TColor.subtext,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: TColor.bg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColor.primary1,
        onPressed: () {
          TColor.tModeDark = !TColor.tModeDark;
          if (mounted) {
            setState(() {});
          }
        },
        child: Icon(
          TColor.tModeDark ? Icons.light_mode : Icons.dark_mode,
          color: TColor.text,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkeysignup,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: media.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        image =
                            await picker.pickImage(source: ImageSource.gallery);

                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: TColor.card,
                            borderRadius:
                                BorderRadius.circular(media.width * 0.15),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 4))
                            ]),
                        child: image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(media.width * 0.15),
                                child: Image.file(
                                  File(image!.path),
                                  width: media.width * 0.18,
                                  height: media.width * 0.18,
                                  fit: BoxFit.cover,
                                ))
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(media.width * 0.15),
                                child: Image.asset(
                                  "assets/img/user_placeholder.png",
                                  width: media.width * 0.18,
                                  height: media.width * 0.18,
                                ),
                              ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: FractionalOffset.bottomRight,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: TColor.primary1,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 20,
                              color: TColor.text,
                            ),
                            onPressed: () async {
                              image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Add profile picture",
                  style: TextStyle(
                      color: TColor.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundTextField(
                  title: "FIRST NAME",
                  hintText: "first name here",
                  controller: txtFirstName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundTextField(
                  title: "LAST NAME",
                  hintText: "last name here",
                  controller: txtLastName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your last name.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundTextField(
                  title: "EMAIL",
                  hintText: "enter your email",
                  keyboardType: TextInputType.emailAddress,
                  controller: txtEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundTextField(
                  title: "PASSWORD",
                  hintText: "create a password",
                  obscureText: !isPasswordVisible,
                  controller: txtPassword,
                  right: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 17),
                      child: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color:
                            isPasswordVisible ? TColor.primary1 : Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundTextField(
                  title: "CONFIRM PASSWORD",
                  hintText: "confirm your password",
                  obscureText: !isConfirmPasswordVisible,
                  controller: txtConfirmPassword,
                  right: GestureDetector(
                    onTap: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 17),
                      child: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isConfirmPasswordVisible
                            ? TColor.primary1
                            : Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                  isLoading: isLoading,
                  title: "REGISTER",
                  onPressed: () async {
                    if (_formkeysignup.currentState!.validate()) {
                      setState(() {
                        name = txtFirstName.text.trim();
                        lastName = txtLastName.text.trim();
                        email = txtEmail.text.trim();
                        password = txtPassword.text.trim();
                        confirmPassword = txtConfirmPassword.text.trim();
                      });
                      register();
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.only(
      //     bottom: MediaQuery.of(context).size.width * 1.2, left: 20, right: 20),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.redAccent,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    ),
  );
}
