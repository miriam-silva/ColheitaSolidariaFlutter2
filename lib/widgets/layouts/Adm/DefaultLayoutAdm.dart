import 'package:flutter/material.dart';
import '../../Header/Drawer/Drawer.dart'; 

class DefaultLayoutAdmin extends StatelessWidget {
  final Widget child;

  const DefaultLayoutAdmin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA50000),
        title: const Text("Colheita Solidária"),
        centerTitle: true,

        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const CircleAvatar(
                backgroundImage: AssetImage("assets/receptor.png"),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),

      drawer: const MeuDrawer(role: "admin"),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}