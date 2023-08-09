import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nildesapp/constant/app_color_contants.dart';
import 'package:nildesapp/ui/widget/primary_button.dart';

import 'master_quiz_create.dart';

class MasterQuiz extends StatefulWidget {
  const MasterQuiz({Key? key}) : super(key: key);

  @override
  State<MasterQuiz> createState() => _MasterQuizState();
}

class _MasterQuizState extends State<MasterQuiz> {
  // text fields' controllers
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _opt1Controller = TextEditingController();
  final TextEditingController _opt2Controller = TextEditingController();
  final TextEditingController _opt3Controller = TextEditingController();
  final TextEditingController _opt4Controller = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  String? answer;

  bool isSeletectedAnswers = false;

  final CollectionReference _item =
      FirebaseFirestore.instance.collection('quiz');

  @override
  void initState() {
    super.initState();
  }

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _questionController.text = documentSnapshot['question'];
      _opt1Controller.text = documentSnapshot['option1'];
      _opt2Controller.text = documentSnapshot['option2'];
      _opt3Controller.text = documentSnapshot['option3'];
      _opt4Controller.text = documentSnapshot['option4'];
      answer = documentSnapshot['answer'];
      _valueController.text = documentSnapshot['value'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isSeletectedAnswers == true
                    ? "Tentukan jawaban"
                    : 'Membuat pertanyaan'),
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  answer = _opt1Controller.text;
                                });
                              },
                              child: TextField(
                                controller: _opt1Controller,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelText: answer == _opt1Controller.text
                                        ? "jawaban dipilih"
                                        : 'Opsi 1'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  answer = _opt2Controller.text;
                                });
                              },
                              child: TextField(
                                readOnly: true,
                                controller: _opt2Controller,
                                decoration: InputDecoration(
                                    labelText: answer == _opt2Controller.text
                                        ? "jawaban dipilih"
                                        : 'Opsi 2'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  answer = _opt3Controller.text;
                                });
                              },
                              child: TextField(
                                readOnly: true,
                                controller: _opt3Controller,
                                decoration: InputDecoration(
                                    labelText: answer == _opt3Controller.text
                                        ? "jawaban dipilih"
                                        : 'Opsi 3'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  answer = _opt4Controller.text;
                                });
                              },
                              child: TextField(
                                readOnly: true,
                                controller: _opt4Controller,
                                decoration: InputDecoration(
                                    labelText: answer == _opt4Controller.text
                                        ? "jawaban dipilih"
                                        : 'Opsi 4'),
                              ),
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
                        final String quiz = _questionController.text;
                        final String opt1 = _opt1Controller.text;
                        final String opt2 = _opt2Controller.text;
                        final String opt3 = _opt3Controller.text;
                        final String opt4 = _opt4Controller.text;
                        final String answers = answer ?? '';

                        final int? value = int.tryParse(_valueController.text);
                        // ignore: unnecessary_null_comparison
                        if (quiz.isNotEmpty && opt1.isNotEmpty) {
                          if (action == 'create') {
                            // Persist a new product to Firestore
                            await _item.add({
                              "question": quiz,
                              "value": value,
                              "option1": opt1,
                              "option2": opt2,
                              "option3": opt3,
                              "option4": opt4,
                              "answer": answers
                            });
                          }

                          if (action == 'update') {
                            // Update the product

                            await _item.doc(documentSnapshot!.id).update({
                              "question": quiz,
                              "value": value,
                              "option1": opt1,
                              "option2": opt2,
                              "option3": opt3,
                              "option4": opt4,
                              "answer": answers
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
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _item.doc(productId).delete();

    // Show a snackbar
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Kuis',
            style: TextStyle(color: AppColor.textWhiteColor)),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _item.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                // ignore: unnecessary_null_comparison
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['question']),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            const Text("Jawaban : "),
                            Text(
                              documentSnapshot['answer'].toString(),
                              style: const TextStyle(
                                  color: AppColor.textBlueColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Point : "),
                            Text(
                              documentSnapshot['value'].toString(),
                              style: const TextStyle(
                                  color: AppColor.textGreenColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MasterQuizCreate(
                                              documentSnapshot:
                                                  documentSnapshot,
                                            )),
                                  )),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MasterQuizCreate()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
