import 'dart:async';

import 'package:flutter/material.dart';

import 'login_screen.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {

Timer? _timer;
int _start = 5;

@override
  void initState() {
    startTimer();
    super.initState();
  }

void startTimer() {
  const oneSec = Duration(seconds: 1);
  _timer =  Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
           Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );

        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}

@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(child: Center(child: Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/splash_nildes.png"), fit: BoxFit.fill),
    ),
  ))),
    );
  }

  // Widget iconLogo = Container(
  //   height: MediaQuery.of(context).size.height,
  //   width: 400,
  //   decoration: const BoxDecoration(
  //     image: DecorationImage(
  //         image: AssetImage("assets/images/splashscreen.png"), fit: BoxFit.fill),
  //   ),
  // );
}
