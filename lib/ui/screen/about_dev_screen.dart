import 'package:flutter/material.dart';
import 'package:nildesapp/ui/widget/secondary_button.dart';

import '../../constant/app_color_contants.dart';

class AboutDevScreen extends StatefulWidget {
  const AboutDevScreen({Key? key}) : super(key: key);

  @override
  State<AboutDevScreen> createState() => _AboutDevScreenState();
}

class _AboutDevScreenState extends State<AboutDevScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Tentang Aplikasi"),
        centerTitle: true,
      ),
      body: ListView(children: [
        //   _buildHeader(),
        _buildBody()
      ]),
    );
  }

  Widget iconLogo = Container(
    height: 100,
    width: 400,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/nildes_header_icon.png"), fit: BoxFit.none),
    ),
  );
  Widget devLogo = Container(
    height: 400,
    width: 400,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/akbar.png"), fit: BoxFit.fitHeight),
    ),
  );

  Widget _buildHeader() {
    return Column(
      children: [
        iconLogo,
        const Divider(
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: const [
              Text("いらっしゃいませ (Selamat Datang)",
                  style: TextStyle(
                      color: AppColor.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        
        //SecondaryButton(onpressed: () {}, textLabel: "Tentang Aplikasi"),
        
        devLogo,
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Muhammad Akbar Abdillah",
          style: TextStyle(
              color: AppColor.primaryColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "201943500434",
          style: TextStyle(
              color: AppColor.secondColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 100,
        ),
        const Divider(),
        const Text(
          "Teknik Informatika",
          style: TextStyle(
              color: AppColor.secondColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "@2023 Universitas Indraprasta PGRI",
          style: TextStyle(
              color: AppColor.secondColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        //_ranking(),
      ],
    );
  }
}
