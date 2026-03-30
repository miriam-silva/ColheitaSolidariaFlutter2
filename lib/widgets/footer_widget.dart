import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF6C973),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [

          // 🔶 LOGO
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
            child: Image.asset(
              'assets/lgtpsolo.png',
              width: 60,
            ),
          ),

          const SizedBox(height: 10),

          // 🔸 TEXTO
          const Text(
            'Colheita Solidária: Juntos plantamos esperança, cultivamos solidariedade e colhemos um futuro melhor para todos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}