import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nildesapp/services/auth_firebase_helper.dart';
import 'package:nildesapp/ui/screen/login_screen.dart';

import '../../constant/app_color_contants.dart';
import '../widget/primary_button.dart';
import 'about_dev_screen.dart';
import 'about_jepang.dart';
import 'master_kosakata.dart';
//import 'master_quizenglish.dart';
import 'master_materi.dart';
import 'master_quiz.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key, required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String headerLabel = "Ayo uji pemahaman kamu disini";
  String userRole = '';

  @override
  void initState() {
    // TODO: implement initState

    loadUserData();
    super.initState();
  }

  void loadUserData() async {
    debugPrint("uid : ${widget.currentUser.uid}");
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection("user")
         .doc(widget.currentUser.uid)
        //.doc('1Bpp8aQyUChzwj5JeYEuG2opuDp1')
        .get()
        .then((value) {
      debugPrint(value.toString());
      setState(() {
        userRole = value['role'];

        debugPrint('role : $userRole');
      });
    });
  }

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
          const SizedBox(
            height: 50,
          ),
          PrimaryButton(
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutDevScreen()),
                );
              },
              textLabel: "Tentang Aplikasi"),
          // const SizedBox(
          //   height: 20,
          // ),
          // PrimaryButton(
          //     onpressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => const AboutJapan()),
          //       );
          //     },
          //     textLabel: "Tentang Jepang"),
          userRole == "admin"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // PrimaryButton(
                    //     onpressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 const MasterQuizHiraScreen()),
                    //       );
                    //     },
                    //     textLabel: "Master Kuis Bahasa Inggris"),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                        onpressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MasterQuiz()),
                          );
                        },
                        textLabel: "Master Kuis"),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                        onpressed: () {
                          admincheck();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     MasterMateri(  isadmin: isadmin,)),
                          );
                        },
                        textLabel: "Master Materi"),
                    const SizedBox(
                      height: 20,
                    ),
                    /*
                    PrimaryButton(
                        onpressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MasterKosakata(
                                      category: "keluarga",
                                      isViewOnly: false,
                                    )),
                          );
                        },
                        textLabel: "Master Keluarga"),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                        onpressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MasterKosakata(
                                      category: "hewan",
                                      isViewOnly: false,
                                    )),
                          );
                        },
                        textLabel: "Master Hewan"),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                        onpressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MasterKosakata(
                                      category: "hari",
                                      isViewOnly: false,
                                    )),
                          );
                        },
                        textLabel: "Master Hari"),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                        onpressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MasterKosakata(
                                      category: "buah",
                                      isViewOnly: false,
                                    )),
                          );
                        },
                        textLabel: "Master Buah"),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                        onpressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MasterKosakata(
                                      category: "tubuh",
                                      isViewOnly: false,
                                    )),
                          );
                        },
                        textLabel: "Master Bagian Tubuh"),
                        */
                  ],
                )
              : Container(),
              
          const SizedBox(
            height: 20,
          ),
          PrimaryButton(
              onpressed: () {
                AuthenticationHelper().signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => const LoginScreen()),
                    (route) => false);
              },
              textLabel: "Keluar"),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

bool isadmin = false;
    Future admincheck() async {
    var collection = FirebaseFirestore.instance.collection('user');
    var docSnapshot = await collection.doc(widget.currentUser.uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      String adminstatus = data?['role'];
      if (adminstatus == 'admin') {
        setState(() {
          isadmin = true;
        });
      }
      debugPrint('is role $isadmin');
    }
  }
}
