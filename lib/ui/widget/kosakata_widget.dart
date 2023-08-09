import 'package:flutter/material.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:nildesapp/constant/app_color_contants.dart';

import '../screen/master_kosakata.dart';

// ignore: must_be_immutable
class KosakataWidget extends StatelessWidget {
  KosakataWidget({Key? key, required this.textLabel, required this.toTranslate})
      : super(key: key);

  final String textLabel;
  final String toTranslate;
  var kanaKit = const KanaKit();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MasterKosakata(
                    category: textLabel,
                    isViewOnly: true,
                  )),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Row(
            children: [
              Text(textLabel.toString(),
                  style: const TextStyle(
                      color: AppColor.textColor, fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 5,
              ),
              Text("( $toTranslate )",
                  style: const TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Hiragana",
                      style: TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(kanaKit.toHiragana(toTranslate),
                      style: const TextStyle(
                          color: AppColor.secondColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Katakana",
                      style: TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(kanaKit.toKatakana(toTranslate),
                      style: const TextStyle(
                          color: AppColor.textBlueColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
