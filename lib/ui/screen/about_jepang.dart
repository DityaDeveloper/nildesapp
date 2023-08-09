import 'package:flutter/material.dart';
import '../../constant/app_color_contants.dart';

class AboutJapan extends StatefulWidget {
  const AboutJapan({Key? key}) : super(key: key);

  @override
  State<AboutJapan> createState() => _AboutJapanState();
}

class _AboutJapanState extends State<AboutJapan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tentang Jepang",
        ),
        centerTitle: true,
      ),
      body: ListView(children: [devLogo, _buildBody()]),
    );
  }

  Widget iconLogo = Container(
    height: 100,
    width: 400,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/header_home.png"), fit: BoxFit.none),
    ),
  );
  Widget devLogo = Container(
    height: 200,
    width: 400,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/jepang.png"), fit: BoxFit.fill),
    ),
  );

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: const [
          Divider(),
          Text(
            "Jepang",
            style: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Jepang (Jepang: 日本国, Tentang suara ini Nihonkoku) adalah sebuah negara kepulauan di Asia Timur. Letaknya di ujung barat Samudra Pasifik, di sebelah timur Laut Jepang, dan bersebelahan dengan Tiongkok, Korea Selatan, dan Rusia. Pulau-pulau paling utara berada di Laut Okhotsk, dan wilayah paling selatan berupa kelompok pulau-pulau kecil di Laut Tiongkok Timur, tepatnya di sebelah selatan Okinawa yang bersebrangan dengan Taiwan. Jepang terdiri dari 6.852 pulau dan menjadikannya sebagai negara kepulauan. Pulau-pulau utama dari utara ke selatan adalah Hokkaido, Honshu (pulau terbesar), Shikoku, dan Kyushu. Sekitar 97% wilayah daratan Jepang berada di keempat pulau terbesarnya. Sebagian besar pulau di Jepang bergunung-gunung, dan sebagian di antaranya merupakan gunung berapi. Gunung tertinggi di Jepang adalah Gunung Fuji yang merupakan sebuah gunung berapi. Penduduk Jepang berjumlah 128 juta jiwa, dan berada di peringkat ke-10 negara berpenduduk terbanyak di dunia. Tokyo secara de facto merupakan ibu kota Jepang, an berkedudukan sebagai sebuah prefektur. Tokyo Raya adalah sebutan untuk Tokyo dan beberapa kota yang berada di prefektur sekelilingnya. Sebagai daerah metropolitan terluas di dunia, Tokyo Raya berpenduduk lebih dari 30 juta orang.",
            style: TextStyle(
                color: AppColor.secondColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 180,
          ),
          Divider(),
          Text(
            "Teknik Informatika",
            style: TextStyle(
                color: AppColor.secondColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "@2022",
            style: TextStyle(
                color: AppColor.secondColor, fontWeight: FontWeight.bold),
          ),
          //_ranking(),
        ],
      ),
    );
  }
}
