import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nildesapp/model/quiz_model.dart';
import 'package:nildesapp/ui/widget/primary_button.dart';
import 'package:nildesapp/ui/widget/quiz_detail_widget.dart';

import '../../constant/app_color_contants.dart';
import '../../services/quiz_firebase_helper.dart';
import '../../services/shared_pref.dart';

class QuizWidget extends StatefulWidget {
  const QuizWidget(
      {Key? key,
      required this.category,
      required this.dbpath,
      required this.currentUser})
      : super(key: key);
  final String category;
  final String dbpath;
  final User currentUser;

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  final CollectionReference db =
      FirebaseFirestore.instance.collection('ranking');
  bool isVisibleQuiz = false;
  bool isArchivment = false;

  int finalResult = 0;

  @override
  Widget build(BuildContext context) {
    // final CollectionReference db =
    //     FirebaseFirestore.instance.collection(widget.dbpath);
    return Scaffold(
      appBar: isVisibleQuiz == true
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(widget.category.toUpperCase()),
              backgroundColor: AppColor.primaryColor,
            )
          : AppBar(
              title: Text(widget.category.toUpperCase()),
              backgroundColor: AppColor.primaryColor,
            ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
            child: Column(
              children: [
                Container(
                  child: isVisibleQuiz == false
                      ? Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColor.primaryColor,
                            ),
                          ),
                          child: const Center(
                              child: Text(
                            "Tap Mulai Kuis, Selesaikan tantangan dan dapatkan skor tertinggi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColor.backgroundColour,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                        )
                      : Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColor.primaryColor,
                            ),
                          ),
                          child: const Center(
                              child: Text(
                            "Dengan melakukan tap selesai maka kamu akan melihat skor akhir",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColor.secondColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: isVisibleQuiz == false
                      ? PrimaryButton(
                          onpressed: () {
                            setState(() {
                              isVisibleQuiz = true;
                              isArchivment = false;
                            });
                          },
                          textLabel: "Mulai Kuis")
                      : PrimaryButton(
                          onpressed: () async {
                            setState(() {
                              isVisibleQuiz = false;
                              isArchivment = true;
                            });
                            await SharedPrefDitya.instance
                                .getIntegerValue("point")
                                .then((value) => finalResult = value ?? 0);
                            debugPrint("nilai akhir ${finalResult.toString()}");
                            debugPrint(
                                "${widget.currentUser.email} - $finalResult - ${widget.category}");
                            await db.add({
                              "name": widget.currentUser.email,
                              "rank": finalResult,
                              "tipe": widget.category
                            });
                            await SharedPrefDitya.instance
                                .removeSharPrefValue("point");
                          },
                          textLabel: "Selesai"),
                ),
                Container(
                  child: isArchivment == true
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Selamat ${widget.currentUser.email},",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: AppColor.backgroundColour,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Nilai Kamu : $finalResult",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: AppColor.primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: isVisibleQuiz == true
                ? StreamBuilder(
                    stream:  FirestoreService().getQuizIndonesia(),
                    builder: (context,
                        AsyncSnapshot<List<QuizModel>> streamSnapshot) {
                      // ignore: unnecessary_string_interpolations
                      debugPrint("${streamSnapshot.data.toString()}");
                      if (streamSnapshot.hasData) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            QuizModel quizmodel = streamSnapshot.data![index];

                            // ignore: unnecessary_null_comparison
                            return Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text("Pertanyaan ${index + 1}"),
                                  subtitle: Container(),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            child: IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_forward),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            QuizDetailWidget(
                                                                quizmodel:
                                                                    quizmodel)),
                                                  );
                                                })),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
