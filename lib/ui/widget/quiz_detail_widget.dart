import 'dart:async';

import 'package:flutter/material.dart';

import 'package:nildesapp/model/quiz_model.dart';
import 'package:nildesapp/services/shared_pref.dart';
import 'package:nildesapp/ui/widget/primary_button.dart';

import '../../constant/app_color_contants.dart';

class QuizDetailWidget extends StatefulWidget {
  const QuizDetailWidget({Key? key, required this.quizmodel}) : super(key: key);
  final QuizModel quizmodel;
  @override
  State<QuizDetailWidget> createState() => _QuizDetailWidgetState();
}

class _QuizDetailWidgetState extends State<QuizDetailWidget> {
  bool isAnswer = false;
  // bool isQuizActived = false;

  Timer? _timer;
  int _start = 10;
  String resultLabel = "";

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            //  isQuizActived = true;
            widget.quizmodel.isActivedQuiz = true;
            debugPrint("kuis ditutup");
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            debugPrint("timer $_start");
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColor.primaryColor),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
              
                Container(
                  child: widget.quizmodel.isActivedQuiz != true
                      ? Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.primaryColor),
                          child: Center(
                            child: Text(
                              _start.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: AppColor.textWhiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.primaryColor),
                          child: const Center(
                            child: Text(
                              "Kuis sudah ditutup",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColor.textWhiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Pertanyaan",
                      style: TextStyle(color: AppColor.textColor, fontSize: 18),
                    ),
                    Text(
                      " (Bobot Nilai ${widget.quizmodel.value} )",
                      style: const TextStyle(
                          color: AppColor.primaryColor, fontSize: 18),
                    ),
                  ],
                ),
                 const SizedBox(
                  height: 20,
                ),
                  SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.network(widget.quizmodel.image),),
                    const SizedBox(
                  height: 20,
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
                      child: Text(
                    widget.quizmodel.question,
                    style: const TextStyle(
                        color: AppColor.backgroundColour,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  onpressed: () async {
                    if (widget.quizmodel.isActivedQuiz == false) {
                      if (_start != 0) {
                        if (widget.quizmodel.option1 ==
                            widget.quizmodel.answer) {
                          int i = 0;
                          await SharedPrefDitya.instance
                              .getIntegerValue("point")
                              .then((value) => i = value ?? 0);
                          debugPrint("nilai sebelumnya ${i.toString()}");
                          int? n = widget.quizmodel.value;
                          if (i != 0) {
                            int valueQuiz = i + n;
                            debugPrint(
                                "nilai tersimpan ${valueQuiz.toString()}");
                            await SharedPrefDitya.instance
                                .setIntegerValue('point', valueQuiz);
                            widget.quizmodel.isActivedQuiz = true;
                          } else {
                            widget.quizmodel.isActivedQuiz = true;
                            debugPrint(
                                "nilai tersimpan ${widget.quizmodel.value.toString()}");
                            await SharedPrefDitya.instance.setIntegerValue(
                                'point', widget.quizmodel.value);
                          }
                          setState(() {
                            isAnswer = true;

                            resultLabel = "Selamat kamu benar";
                            widget.quizmodel.tempAnswerLabel = resultLabel;
                            String result = "Selamat kamu benar";
                            final snackBar = SnackBar(
                              content: Text(result),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        } else {
                          setState(() {
                            widget.quizmodel.isActivedQuiz = true;
                            isAnswer = false;
                            resultLabel = "Jawaban kamu salah";
                            widget.quizmodel.tempAnswerLabel = resultLabel;
                            String result = resultLabel;
                            final snackBar = SnackBar(
                              content: Text(result),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      } else {
                        setState(() {
                          widget.quizmodel.isActivedQuiz = true;
                          resultLabel = "Waktu kamu habis";
                          widget.quizmodel.tempAnswerLabel = resultLabel;

                          // isQuizActived = true;
                        });
                      }
                    } else {
                      widget.quizmodel.isActivedQuiz = true;
                      String result = "kuis ini sudah ditutup";
                      final snackBar = SnackBar(
                        content: Text(result),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    int finalResult = 0;
                    await SharedPrefDitya.instance
                        .getIntegerValue("point")
                        .then((value) => finalResult = value ?? 0);
                    debugPrint("nilai akhir ${finalResult.toString()}");
                  },
                  textLabel: "A. ${widget.quizmodel.option1}",
                ),
                PrimaryButton(
                  onpressed: () async {
                    if (widget.quizmodel.isActivedQuiz == false) {
                      if (_start != 0) {
                        if (widget.quizmodel.option2 ==
                            widget.quizmodel.answer) {
                          int i = 0;
                          await SharedPrefDitya.instance
                              .getIntegerValue("point")
                              .then((value) => i = value ?? 0);
                          debugPrint("nilai sebelumnya ${i.toString()}");
                          int? n = widget.quizmodel.value;
                          if (i != 0) {
                            int valueQuiz = i + n;
                            debugPrint(
                                "nilai tersimpan ${valueQuiz.toString()}");
                            await SharedPrefDitya.instance
                                .setIntegerValue('point', valueQuiz);
                            widget.quizmodel.isActivedQuiz = true;
                          } else {
                            widget.quizmodel.isActivedQuiz = true;
                            debugPrint(
                                "nilai tersimpan ${widget.quizmodel.value.toString()}");
                            await SharedPrefDitya.instance.setIntegerValue(
                                'point', widget.quizmodel.value);
                          }
                          setState(() {
                            isAnswer = true;
                            widget.quizmodel.isActivedQuiz = true;
                            resultLabel = "Selamat kamu benar";
                            widget.quizmodel.tempAnswerLabel = resultLabel;
                            String result = "Selamat kamu benar";
                            final snackBar = SnackBar(
                              content: Text(result),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        } else {
                          setState(() {
                            isAnswer = false;
                            resultLabel = "Jawaban kamu salah";
                            widget.quizmodel.tempAnswerLabel = resultLabel;
                            String result = resultLabel;
                            final snackBar = SnackBar(
                              content: Text(result),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            widget.quizmodel.isActivedQuiz = true;
                          });
                        }
                      } else {
                        setState(() {
                          widget.quizmodel.isActivedQuiz = true;
                          resultLabel = "Waktu kamu habis";
                          widget.quizmodel.tempAnswerLabel = resultLabel;
                          // isQuizActived = true;
                        });
                      }
                    } else {
                      String result = "kuis ini sudah ditutup";
                      final snackBar = SnackBar(
                        content: Text(result),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        widget.quizmodel.isActivedQuiz = true;
                      });
                    }
                    int finalResult = 0;
                    await SharedPrefDitya.instance
                        .getIntegerValue("point")
                        .then((value) => finalResult = value ?? 0);
                    debugPrint("nilai akhir ${finalResult.toString()}");
                  },
                  textLabel: "B. ${widget.quizmodel.option2}",
                ),
                PrimaryButton(
                  onpressed: () async {
                    if (widget.quizmodel.isActivedQuiz == false) {
                      if (_start != 0) {
                        if (widget.quizmodel.option3 ==
                            widget.quizmodel.answer) {
                          int i = 0;
                          await SharedPrefDitya.instance
                              .getIntegerValue("point")
                              .then((value) => i = value ?? 0);
                          debugPrint("nilai sebelumnya ${i.toString()}");
                          int? n = widget.quizmodel.value;
                          if (i != 0) {
                            int valueQuiz = i + n;
                            debugPrint(
                                "nilai tersimpan ${valueQuiz.toString()}");
                            await SharedPrefDitya.instance
                                .setIntegerValue('point', valueQuiz);
                            widget.quizmodel.isActivedQuiz = true;
                          } else {
                            widget.quizmodel.isActivedQuiz = true;
                            debugPrint(
                                "nilai tersimpan ${widget.quizmodel.value.toString()}");
                            await SharedPrefDitya.instance.setIntegerValue(
                                'point', widget.quizmodel.value);
                          }
                          setState(() {
                            isAnswer = true;

                            resultLabel = "Selamat kamu benar";
                            widget.quizmodel.tempAnswerLabel = resultLabel;
                            String result = "Selamat kamu benar";
                            final snackBar = SnackBar(
                              content: Text(result),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            widget.quizmodel.isActivedQuiz = true;
                          });
                        } else {
                          setState(() {
                            isAnswer = false;
                            resultLabel = "Jawaban kamu salah";
                            widget.quizmodel.tempAnswerLabel = resultLabel;
                            String result = resultLabel;
                            final snackBar = SnackBar(
                              content: Text(result),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            widget.quizmodel.isActivedQuiz = true;
                          });
                        }
                      } else {
                        setState(() {
                          widget.quizmodel.isActivedQuiz = true;
                          resultLabel = "Waktu kamu habis";
                          widget.quizmodel.tempAnswerLabel = resultLabel;
                          // isQuizActived = true;
                        });
                      }
                    } else {
                      String result = "kuis ini sudah ditutup";
                      final snackBar = SnackBar(
                        content: Text(result),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      widget.quizmodel.isActivedQuiz = true;
                    }
                    int finalResult = 0;
                    await SharedPrefDitya.instance
                        .getIntegerValue("point")
                        .then((value) => finalResult = value ?? 0);
                    debugPrint("nilai akhir ${finalResult.toString()}");
                  },
                  textLabel: "C. ${widget.quizmodel.option3}",
                ),
                PrimaryButton(
                  onpressed: () async {
                    if (widget.quizmodel.isActivedQuiz == false) {
                      if (_start != 0) {
                        if (widget.quizmodel.option4 ==
                            widget.quizmodel.answer) {
                          int i = 0;
                          await SharedPrefDitya.instance
                              .getIntegerValue("point")
                              .then((value) => i = value ?? 0);
                          debugPrint("nilai sebelumnya ${i.toString()}");
                          int? n = widget.quizmodel.value;
                          if (i != 0) {
                            int valueQuiz = i + n;
                            debugPrint(
                                "nilai tersimpan ${valueQuiz.toString()}");
                            await SharedPrefDitya.instance
                                .setIntegerValue('point', valueQuiz);
                            widget.quizmodel.isActivedQuiz = true;
                          } else {
                            widget.quizmodel.isActivedQuiz = true;
                            debugPrint(
                                "nilai tersimpan ${widget.quizmodel.value.toString()}");
                            await SharedPrefDitya.instance.setIntegerValue(
                                'point', widget.quizmodel.value);
                          }
                          setState(() {
                            isAnswer = true;

                            resultLabel = "Selamat kamu benar";
                            widget.quizmodel.tempAnswerLabel = resultLabel;
                            String result = "Selamat kamu benar";
                            final snackBar = SnackBar(
                              content: Text(result),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            widget.quizmodel.isActivedQuiz = true;
                          });
                        } else {
                          setState(() {
                            isAnswer = false;
                            widget.quizmodel.isActivedQuiz = true;
                            resultLabel = "Jawaban kamu salah";
                            widget.quizmodel.tempAnswerLabel = resultLabel;
                            String result = resultLabel;
                            final snackBar = SnackBar(
                              content: Text(result),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      } else {
                        setState(() {
                          widget.quizmodel.isActivedQuiz = true;
                          resultLabel = "Waktu kamu habis";
                          widget.quizmodel.tempAnswerLabel = resultLabel;
                          // isQuizActived = true;
                        });
                      }
                    } else {
                      String result = "kuis ini sudah ditutup";
                      final snackBar = SnackBar(
                        content: Text(result),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    int finalResult = 0;
                    await SharedPrefDitya.instance
                        .getIntegerValue("point")
                        .then((value) => finalResult = value ?? 0);
                    debugPrint("nilai akhir ${finalResult.toString()}");
                  },
                  textLabel: "D. ${widget.quizmodel.option4}",
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: SizedBox(
              height: 80,
              child: widget.quizmodel.isActivedQuiz == true
                  ? Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColor.primaryColor,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        widget.quizmodel.tempAnswerLabel ?? '',
                        style: const TextStyle(
                            color: AppColor.backgroundColour,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      )),
                    )
                  : Container(),
            ),
          ),
        ]),
      ),
    );
  }
}
