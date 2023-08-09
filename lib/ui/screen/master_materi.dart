import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nildesapp/constant/app_color_contants.dart';
import 'package:nildesapp/ui/screen/master_materi_create.dart';
import 'package:nildesapp/ui/widget/primary_button.dart';

import 'master_quiz_create.dart';

class MasterMateri extends StatefulWidget {
  const MasterMateri({Key? key, required this.isadmin}) : super(key: key);
  final bool isadmin;
  @override
  State<MasterMateri> createState() => _MasterMateriState();
}

class _MasterMateriState extends State<MasterMateri> {
  // text fields' controllers
  final TextEditingController _questionController = TextEditingController();

  final CollectionReference _item =
      FirebaseFirestore.instance.collection('materi');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _questionController.text = documentSnapshot['question'];
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
                Center(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(labelText: 'Pertanyaan'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                widget.isadmin == false
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PrimaryButton(
                            onpressed: () async {
                              final String quiz = _questionController.text;

                              // ignore: unnecessary_null_comparison
                              if (quiz.isNotEmpty) {
                                if (action == 'create') {
                                  // Persist a new product to Firestore
                                  await _item.add({
                                    "question": quiz,
                                  });
                                }

                                if (action == 'update') {
                                  // Update the product

                                  await _item.doc(documentSnapshot!.id).update({
                                    "question": quiz,
                                  });
                                }

                                // Clear the text fields
                                _questionController.text = '';

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
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a quiz')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Materi',
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
                return GestureDetector(
                  onTap: () => {
                    if (widget.isadmin == false)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MasterMateriCreate(
                                    documentSnapshot: documentSnapshot,
                                    isadmin: widget.isadmin,
                                  )),
                        )
                      }
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(documentSnapshot['image'],
                                width: 250, height: 250, fit: BoxFit.fill),
                            SizedBox(
                                height: 40,
                                child: Text(documentSnapshot['question'],
                                    overflow: TextOverflow.ellipsis)),
                          ]),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            // Press this button to edit a single product
                            if (widget.isadmin)
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MasterMateriCreate(
                                                  documentSnapshot:
                                                      documentSnapshot,
                                                  isadmin: widget.isadmin,
                                                )),
                                      )),
                            // This icon button is used to delete a single product
                            if (widget.isadmin)
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteProduct(documentSnapshot.id)),
                          ],
                        ),
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
          if (widget.isadmin == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MasterMateriCreate(
                        isadmin: widget.isadmin,
                      )),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
