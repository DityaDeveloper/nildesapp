import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:nildesapp/constant/app_color_contants.dart';
import 'package:nildesapp/constant/share_pref.dart';
import 'package:nildesapp/ui/screen/dashboard_screen.dart';
import 'package:nildesapp/ui/screen/home_screen.dart';

import '../../services/auth_firebase_helper.dart';
import 'splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('user');

  bool isPasswordVisible = true;

  String _buttonLabel = "login";
  String _toRegisterLabel = "Buat akun baru disini";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(children: [
          _buildHeader(),
          _buildBody(),
          _buildBottom(),
        ]),
      ),
    );
  }

  Widget iconLogo = Container(
    height: 400,
    width: 380,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/logo_nildes.png"), fit: BoxFit.fill),
    ),
  );

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          iconLogo,
          const SizedBox(
            height: 30,
          ),
          Text(
            _buttonLabel == "login" ? "login" : "daftar",
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColor.secondColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    isPasswordVisible
                        ? isPasswordVisible = false
                        : isPasswordVisible = true;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColor.primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: AppColor.primaryColor)))),
            onPressed: () {
              //if (_buttonLabel == "login") {}
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => const HomeScreen()),
              //   (Route<dynamic> route) => false,
              // );

              var email = _emailController.text;
              var password = _passwordController.text;
              if (_buttonLabel == "login") {
                AuthenticationHelper()
                    .signIn(email: email, password: password)
                    .then((result) {
                  if (result == null) {
                    var currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      debugPrint("current user : ${currentUser.uid}");
                      DityaSharedPreferences.instance
                          .setStringValue("token", currentUser.uid);
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(currentUser: currentUser!)));
                  } else {
                    final snackBar = SnackBar(
                      content: Text(result),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              } else {
                AuthenticationHelper()
                    .signUp(email: email, password: password)
                    .then((result) {
                  if (result == null) {
                    var currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      debugPrint("current user : ${currentUser.uid}");
                      _users.doc(currentUser.uid.toString()).set({
                        "email": currentUser.email,
                        "role": "user",
                        "uid": currentUser.uid
                      });
                      debugPrint("Create user success");
                      DityaSharedPreferences.instance
                          .setStringValue("token", currentUser.uid);
                    }

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  currentUser: currentUser!,
                                )));
                  } else {
                    final snackBar = SnackBar(
                      content: Text(result),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              }
            },
            child: Text(
              _buttonLabel == "login" ? "login" : "daftar",
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return GestureDetector(
      onTap: () {
        if (_buttonLabel == "login") {
          setState(() {
            _buttonLabel = "daftar";
            _toRegisterLabel = "sudah memiliki akun";
          });
        } else {
          setState(() {
            _buttonLabel = "login";
            _toRegisterLabel = "buat akun baru disini";
          });
        }
      },
      child: Center(
          child: Text(
        _toRegisterLabel,
        style: const TextStyle(color: AppColor.secondTextColor),
      )),
    );
  }
}
