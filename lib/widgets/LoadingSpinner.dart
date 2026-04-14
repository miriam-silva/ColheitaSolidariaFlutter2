import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final double size;
  final Color color;

  const LoadingSpinner({
    super.key,
    this.size = 60,
    this.color = const Color(0xFFA50000),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: size * 0.1, 
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}