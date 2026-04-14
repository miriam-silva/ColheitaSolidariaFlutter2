import 'package:flutter/material.dart';
import '../../Header/HeaderHome.dart';
import '../../Navbar/NavbarHome.dart';
import '../../Footer.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;

  const DefaultLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(),
          const NavbarWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  child, 
                  const SizedBox(height: 30),
                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}