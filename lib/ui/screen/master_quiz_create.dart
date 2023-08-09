import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nildesapp/constant/app_color_contants.dart';

import '../widget/primary_button.dart';

class MasterQuizCreate extends StatefulWidget {
  const MasterQuizCreate({Key? key, this.documentSnapshot})
      : super(key: key);
  final DocumentSnapshot? documentSnapshot;
  @override
  State<MasterQuizCreate> createState() => _MasterQuizCreateState();
}

class _MasterQuizCreateState extends State<MasterQuizCreate> {
  // text fields' controllers
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _opt1Controller = TextEditingController();
  final TextEditingController _opt2Controller = TextEditingController();
  final TextEditingController _opt3Controller = TextEditingController();
  final TextEditingController _opt4Controller = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  String? answer;
  String action = 'create';
  String? urlImage;

  bool isSeletectedAnswers = false;

  final CollectionReference _item =
      FirebaseFirestore.instance.collection('quiz');

  @override
  void initState() {
    loadData(widget.documentSnapshot);
    super.initState();
  }

  Future<void> loadData([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      action = 'update';
      _questionController.text = documentSnapshot['question'];
      _opt1Controller.text = documentSnapshot['option1'];
      _opt2Controller.text = documentSnapshot['option2'];
      _opt3Controller.text = documentSnapshot['option3'];
      _opt4Controller.text = documentSnapshot['option4'];
      answer = documentSnapshot['answer'];
      urlImage = documentSnapshot['image'];
      _valueController.text = documentSnapshot['value'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          title: Text(isSeletectedAnswers == true
              ? "Tentukan jawaban"
              : 'Membuat pertanyaan'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            // prevent the soft keyboard from covering text fields
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                       if(urlImage!= null)
                  Image.network(urlImage!),
                  if(urlImage == null)
                  Center(
                    child: GestureDetector(
                      onTap: getGallery,
                      child: image == null ? const Icon(Icons.photo, size:60, color: AppColor.primaryColor,) : Image.file(image!)),
                  ),
                Center(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(labelText: 'Pertanyaan'),
                  ),
                ),
                SizedBox(
                  child: isSeletectedAnswers == false
                      ? Column(
                          children: [
                       
                            TextField(
                              controller: _opt1Controller,
                              decoration:
                                  const InputDecoration(labelText: 'Opsi 1'),
                            ),
                            TextField(
                              controller: _opt2Controller,
                              decoration:
                                  const InputDecoration(labelText: 'Opsi 2'),
                            ),
                            TextField(
                              controller: _opt3Controller,
                              decoration:
                                  const InputDecoration(labelText: 'Opsi 3'),
                            ),
                            TextField(
                              controller: _opt4Controller,
                              decoration:
                                  const InputDecoration(labelText: 'Opsi 4'),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            // opt 1
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      answer = _opt1Controller.text;
                                      debugPrint("answer is :$answer");
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColor.primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: answer == _opt1Controller.text
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  )
                                                : Container(),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            _opt1Controller.text.isEmpty
                                                ? "Opsi 1"
                                                : _opt1Controller.text,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            // opt 2
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      answer = _opt2Controller.text;
                                      debugPrint("answer is :$answer");
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColor.primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: answer == _opt2Controller.text
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  )
                                                : Container(),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            _opt2Controller.text.isEmpty
                                                ? "Opsi 2"
                                                : _opt2Controller.text,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            // opt 3
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      answer = _opt3Controller.text;
                                      debugPrint("answer is :$answer");
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColor.primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: answer == _opt3Controller.text
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  )
                                                : Container(),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            _opt3Controller.text.isEmpty
                                                ? "Opsi 3"
                                                : _opt3Controller.text,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            // opt 4
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      answer = _opt4Controller.text;
                                      debugPrint("answer is :$answer");
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColor.primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: answer == _opt4Controller.text
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  )
                                                : Container(),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            _opt4Controller.text.isEmpty
                                                ? "Opsi 4"
                                                : _opt4Controller.text,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  controller: _valueController,
                  decoration: const InputDecoration(
                    labelText: 'Nilai',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryButton(
                        onpressed: () {
                          if (isSeletectedAnswers == false) {
                            setState(() {
                              isSeletectedAnswers = true;
                            });
                          } else {
                            setState(() {
                              isSeletectedAnswers = false;
                            });
                          }
                          debugPrint("status selected : $isSeletectedAnswers");
                        },
                        textLabel: isSeletectedAnswers == true
                            ? "membuat pertanyaan"
                            : "tentukan jawaban"),
                    PrimaryButton(
                      onpressed: () async {
                        // ignore: unnecessary_null_comparison
                        if (widget.documentSnapshot != null) {
                          action = 'update';
                          _questionController.text =
                              widget.documentSnapshot!['question'];
                          _opt1Controller.text =
                              widget.documentSnapshot!['option1'];
                          _opt2Controller.text =
                              widget.documentSnapshot!['option2'];
                          _opt3Controller.text =
                              widget.documentSnapshot!['option3'];
                          _opt4Controller.text =
                              widget.documentSnapshot!['option4'];
                          answer = widget.documentSnapshot!['answer'];
                          _valueController.text =
                              widget.documentSnapshot!['value'];
                          answer = widget.documentSnapshot!['answer'];
                        }
                        final String quiz = _questionController.text;
                        final String opt1 = _opt1Controller.text;
                        final String opt2 = _opt2Controller.text;
                        final String opt3 = _opt3Controller.text;
                        final String opt4 = _opt4Controller.text;
                        bool tempQuiz = false;
                        if (answer == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tentukan jawaban')));
                        } else {
                          final String answers = answer!;
          
                          final int? value = int.tryParse(_valueController.text);
                          // ignore: unnecessary_null_comparison
                          if (quiz.isNotEmpty && answers.isNotEmpty) {
                            if (action == 'create') {
                                // Persist a new product to Firestore
                                  File file = File(imageFromCamera!.path);
                                  String? fileName = file.path.split('/').last;
                                  await FirebaseStorage.instance
                                      .ref()
                                      .child('/quiz/')
                                      .child(fileName)
                                      .putFile(File(file.path))
                                      .then((taskSnapshot) {
                                    if (taskSnapshot.state == TaskState.success) {
                                      FirebaseStorage.instance
                                          .ref()
                                          .child('/quiz/')
                                          .child(fileName)
                                          .getDownloadURL()
                                          .then((url) async {
                                            setState(() {
                                              urlImage = url;
                                            });
                                             await _item.add({
                                    "question": quiz,
                                    "value": value,
                                    "option1": opt1,
                                    "option2": opt2,
                                    "option3": opt3,
                                    "option4": opt4,
                                    "image": urlImage,
                                    "answer": answers
                                  });
                                        debugPrint("Here is the URL of Image $url");
                                      });
                                    }
                                  });
                                  debugPrint("task done ==> ${file.path}");
                                 
                                 
                                }
                            }
          
                            if (action == 'update') {
                              // Update the product
          
                              await _item
                                  .doc(widget.documentSnapshot!.id)
                                  .update({
                                "question": quiz,
                                "value": value,
                                "option1": opt1,
                                "option2": opt2,
                                "option3": opt3,
                                "option4": opt4,
                                "answer": answers,
                                "tempquiz": tempQuiz,
                              });
                            }
          
                            // Clear the text fields
                            _questionController.text = '';
                            _opt1Controller.text = '';
                            _opt2Controller.text = '';
                            _opt3Controller.text = '';
                            _opt4Controller.text = '';
                            answer = '';
                            _valueController.text = '';
          
                            // Hide the bottom sheet
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          }
                        
                      },
                      textLabel: action == 'create' ? 'Create' : 'Update',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
  File? image;
  XFile? imageFromCamera;
  List<XFile> imagefiles = [];
  Future getGallery() async {
    imagefiles = [];
    imageFromCamera =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    image = File(imageFromCamera!.path);
    String? fileName = image!.path.split('/').last;
    String? fileExtension = fileName.split('.').last;

    final bytes = image!.readAsBytesSync().lengthInBytes;
    // final kb = bytes / 1024;
    // final ukuranPhoto = kb / 1024;

    if (fileExtension == 'png' ||
        fileExtension == 'jpg' ||
        fileExtension == 'PNG' ||
        fileExtension == 'MIME' ||
        fileExtension == 'mime') {
      setState(() {
        image = File(imageFromCamera!.path);
        //feederController.phoneCtrl.value.text = fileName;
        // getting a directory path for saving
        final String path = image.toString();
        debugPrint('clog ==> ${path.toString()}');
      });
    } else {
      setState(() {
        //   feederController.phoneCtrl.value.text = 'Ukuran photo belum sesuai';
        image = null;
      });
    }
    // ignore: use_build_context_synchronously
  }
}
