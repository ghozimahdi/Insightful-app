import 'package:flutter/material.dart';

class SizedProgressCircular extends StatelessWidget {
  final double size;
  final Color? color;

  const SizedProgressCircular({super.key, this.size = 50, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
