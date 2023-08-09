import 'package:flutter/material.dart';

import '../../constant/app_color_contants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key, required this.onpressed, required this.textLabel})
      : super(key: key);
  final void Function()? onpressed;
  final String textLabel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColor.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: AppColor.primaryColor)))),
      onPressed: onpressed,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          textLabel,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
