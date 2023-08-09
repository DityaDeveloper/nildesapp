import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constant/app_color_contants.dart';
import '../widget/primary_button.dart';
import '../widget/quiz_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key, required this.currentUser}) : super(key: key);
  final User currentUser;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String headerLabel = "Ayo uji pemahaman kamu disini";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        _buildHeader(),
        _buildBody(),
      ]),
    );
  }

  Widget iconLogo = Container(
    height: 100,
    width: 400,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/nildes_header_icon.png"), fit: BoxFit.fitHeight),
    ),
  );

  Widget _buildHeader() {
    return Column(
      children: [
        iconLogo,
        const Divider(
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: const [
              Text("Welcome (Selamat Datang)",
                  style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Text("${widget.currentUser.email}",
                  style: const TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          _msgHeader(),
          const SizedBox(
            height: 50,
          ),
         
          
          PrimaryButton(
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizWidget(
                            currentUser: widget.currentUser,
                            category: "indonesia",
                            dbpath: "quiz",
                          )),
                );
              },
              textLabel: "Kuis"),
          const SizedBox(
            height: 60,
          ),
          _msgBottom()
        ],
      ),
    );
  }

  Widget _msgHeader() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          headerLabel,
          style: const TextStyle(
              color: AppColor.primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      )),
    );
  }

  Widget _msgBottom() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: const Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Selesaikan ujiannya dan dapatkan nilai terbaik kamu",
          style: TextStyle(
            color: AppColor.primaryColor,
            fontSize: 14,
          ),
        ),
      )),
    );
  }
}
