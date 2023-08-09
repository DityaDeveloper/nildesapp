import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:nildesapp/constant/app_color_contants.dart';
import 'package:nildesapp/ui/widget/primary_button.dart';
import 'package:translator/translator.dart';

class MasterKosakata extends StatefulWidget {
  const MasterKosakata(
      {Key? key, required this.category, required this.isViewOnly})
      : super(key: key);
  final String category;
  final bool isViewOnly;

  @override
  State<MasterKosakata> createState() => _MasterKosakataState();
}

class _MasterKosakataState extends State<MasterKosakata> {
  // text fields' controllers
  final translator = GoogleTranslator();
  final TextEditingController _labelNameController = TextEditingController();
  final TextEditingController _categoriController = TextEditingController();
  var kanaKit = const KanaKit();

  String dropdownValue = '';

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _labelNameController.text = documentSnapshot['label'];
      _categoriController.text = documentSnapshot['category'].toString();
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
                TextField(
                  controller: _labelNameController,
                  decoration: const InputDecoration(labelText: 'Label'),
                ),
                const SizedBox(
                  height: 5,
                ),
                PrimaryButton(
                    onpressed: () async {
                      final String name = _labelNameController.text;
                      var japanLabel =
                          await translator.translate(name, to: 'ja');
                      var romanjiLabel =
                          kanaKit.toRomaji(japanLabel.toString());
                      var kanaLabel = kanaKit.toKana(japanLabel.toString());
                      var hiraLabel = kanaKit.toHiragana(japanLabel.toString());
                      debugPrint(
                          "translate : $romanjiLabel - $kanaLabel - $hiraLabel");
                      if (name.isNotEmpty) {
                        if (action == 'create') {
                          // Persist a new items to Firestore
                          final CollectionReference db = FirebaseFirestore
                              .instance
                              .collection(widget.category);
                          await db.add({
                            "label": name,
                            "category": widget.category,
                            "japan": japanLabel.toString(),
                            "kana": kanaLabel,
                            "hira": hiraLabel,
                            "romanji": romanjiLabel,
                          });
                        }

                        if (action == 'update') {
                          // Update the items
                          final CollectionReference db = FirebaseFirestore
                              .instance
                              .collection(widget.category);
                          await db.doc(documentSnapshot!.id).update({
                            "label": name,
                            "category": widget.category,
                            "japan": japanLabel.toString(),
                            "kana": kanaLabel,
                            "hira": hiraLabel,
                            "romanji": romanjiLabel,
                          });
                        }

                        // Clear the text fields
                        _labelNameController.text = '';
                        _categoriController.text = '';

                        // Hide the bottom sheet
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      }
                    },
                    textLabel: action == 'create' ? 'Create' : 'Update')
              ],
            ),
          );
        });
  }

  // Deleteing a items by id
  Future<void> _deleteitems(String itemsId) async {
    final CollectionReference db =
        FirebaseFirestore.instance.collection(widget.category);
    await db.doc(itemsId).delete();

    // Show a snackbar
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a items')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          title: Text(widget.category.toUpperCase()),
        ),
        // Using StreamBuilder to display all itemss from Firestore in real-time
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(widget.category)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  // prints Dart jest bardzo fajny!
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(documentSnapshot['label']),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "( ${documentSnapshot['japan']} )",
                            style:
                                const TextStyle(color: AppColor.primaryColor),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          Row(
                            children: [
                              const Text("Kategori"),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                documentSnapshot['category'].toString(),
                                style: const TextStyle(
                                    color: AppColor.backgroundColour,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text("Hiragana"),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                documentSnapshot['hira'].toString(),
                                style: const TextStyle(
                                    color: AppColor.textBlueColor),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text("Katakana"),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                documentSnapshot['kana'].toString(),
                                style: const TextStyle(
                                    color: AppColor.textGreenColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: widget.isViewOnly == false
                          ? SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  // Press this button to edit a single items
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          _createOrUpdate(documentSnapshot)),
                                  // This icon button is used to delete a single items
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteitems(documentSnapshot.id)),
                                ],
                              ),
                            )
                          : const SizedBox(),
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
        // Add new items
        floatingActionButton: widget.isViewOnly == false
            ? Opacity(
                opacity: 1.0,
                child: FloatingActionButton(
                  backgroundColor: AppColor.primaryColor,
                  onPressed: () => _createOrUpdate(),
                  child: const Icon(Icons.add),
                ),
              )
            : Container());
  }
}
