import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nildesapp/constant/app_color_contants.dart';

import '../widget/primary_button.dart';

class MasterMateriCreate extends StatefulWidget {
  const MasterMateriCreate({Key? key, this.documentSnapshot, required this.isadmin}) : super(key: key);
  final DocumentSnapshot? documentSnapshot;
  final bool isadmin;
  @override
  State<MasterMateriCreate> createState() => _MasterMateriCreateState();
}

class _MasterMateriCreateState extends State<MasterMateriCreate> {
  // text fields' controllers
  final TextEditingController _questionController = TextEditingController();

  String action = 'create';
  String? urlImage;

  bool isSeletectedAnswers = false;

  final CollectionReference _item =
      FirebaseFirestore.instance.collection('materi');

  @override
  void initState() {
    loadData(widget.documentSnapshot);
    super.initState();
  }

  Future<void> loadData([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      action = 'update';
      _questionController.text = documentSnapshot['question'];

      urlImage = documentSnapshot['image'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          title: widget.isadmin == true ?const Text('Membuat Materi') :const Text('Materi'),
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
                if (urlImage != null) Image.network(urlImage!),
                if (urlImage == null)
                  Center(
                    child: GestureDetector(
                        onTap: getGallery,
                        child: image == null
                            ? const Icon(
                                Icons.photo,
                                size: 60,
                                color: AppColor.primaryColor,
                              )
                            : Image.file(image!)),
                  ),
               widget.isadmin == true ?
                Center(
                  child: TextField(
                
                    maxLines: 5,
                    controller: _questionController,
                    decoration: const InputDecoration(labelText: 'Materi'),
                  ),
                ): Center(
                  child: TextField(
                readOnly: true,
                    maxLines: 5,
                    controller: _questionController,
                    decoration: const InputDecoration(labelText: 'Materi'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if(widget.isadmin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   
                    PrimaryButton(
                      onpressed: () async {
                        // ignore: unnecessary_null_comparison
                        if (widget.documentSnapshot != null) {
                          action = 'update';
                          _questionController.text =
                              widget.documentSnapshot!['question'];
                        }
                        final String quiz = _questionController.text;

                        // ignore: unnecessary_null_comparison
                        if (quiz.isNotEmpty) {
                          if (action == 'create') {
                            // Persist a new product to Firestore
                            File file = File(imageFromCamera!.path);
                            String? fileName = file.path.split('/').last;
                            await FirebaseStorage.instance
                                .ref()
                                .child('/materi/')
                                .child(fileName)
                                .putFile(File(file.path))
                                .then((taskSnapshot) {
                              if (taskSnapshot.state == TaskState.success) {
                                FirebaseStorage.instance
                                    .ref()
                                    .child('/materi/')
                                    .child(fileName)
                                    .getDownloadURL()
                                    .then((url) async {
                                  setState(() {
                                    urlImage = url;
                                  });
                                  await _item.add({
                                    "question": quiz,
                                    "image": urlImage,
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

                          await _item.doc(widget.documentSnapshot!.id).update({
                            "question": quiz,
                          });
                        }

                        // Clear the text fields
                        _questionController.text = '';

                        // Hide the bottom sheet
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
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
