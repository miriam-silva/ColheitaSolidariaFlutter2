import 'package:flutter/material.dart';
import '../../Header/Drawer/Drawer.dart';

class DefaultLayout4 extends StatelessWidget {
  final Widget child;

  const DefaultLayout4({
    super.key,
    required this.child,
  });

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

      drawer: const MeuDrawer(
        role: "colaborador",
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          child: child,
        ),
      ),
    );
  }
}