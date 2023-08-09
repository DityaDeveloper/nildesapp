import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../../constant/app_color_contants.dart';
import '../widget/kosakata_widget.dart';
import '../widget/secondary_button.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen(
      {Key? key, required this.pathFoto, required this.labelHeader})
      : super(key: key);
  final String pathFoto;
  final String labelHeader;

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(children: [
        _buildHeader(),
        widget.labelHeader == "kosakata"
            ? _buildKosakata()
            : _buildBody(widget.labelHeader)
      ]),
    );
  }

  String? path;

  @override
  void initState() {
    path = widget.pathFoto;
    super.initState();
  }

  Widget iconLogo = Container(
    height: 100,
    width: 400,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/header_home.png"), fit: BoxFit.none),
    ),
  );

  Widget _buildHeader() {
    return Column(
      children: [iconLogo],
    );
  }

  Widget _buildBody(labelHeader) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SecondaryButton(
              onpressed: () async {}, textLabel: "Belajar $labelHeader"),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/$path.png"),
                  fit: BoxFit.fill),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKosakata() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        KosakataWidget(
          textLabel: "keluarga",
          toTranslate: "Kazoku",
        ),
        KosakataWidget(
          textLabel: "hewan",
          toTranslate: "Dōbutsu",
        ),
        KosakataWidget(
          textLabel: "hari",
          toTranslate: "Hi",
        ),
        KosakataWidget(
          textLabel: "tubuh",
          toTranslate: "Karada",
        ),
        KosakataWidget(
          textLabel: "buah",
          toTranslate: "Furūtsu",
        ),
      ]),
    );
  }
}
