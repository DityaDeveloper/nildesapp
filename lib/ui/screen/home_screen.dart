import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constant/app_color_contants.dart';

import 'about_screen.dart';
import 'dashboard_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    PageController _controller = PageController();
    void onTapIcon(int index) {
      _controller.animateToPage(index,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      //  backgroundColor: AppColor.backgroundColour,
      // appBar: _currentIndex != 2
      //     ? AppBar(
      //         centerTitle: true,
      //         title: _buildTitle(_currentIndex),
      //       )
      //     : null,
      body: PageView(
        controller: _controller,
        children: <Widget>[
          DashboardScreen(
            currentUser: widget.currentUser,
          ),
          QuizScreen(
            currentUser: widget.currentUser,
          ),
          AboutScreen(
            currentUser: widget.currentUser,
          )
        ],
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.primaryColor,
        selectedItemColor: AppColor.secondTextColor,
        unselectedItemColor: AppColor.textWhiteColor,
        onTap: onTapIcon,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "Kuis"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Tentang"),
        ],
      ),
    );
  }
}
