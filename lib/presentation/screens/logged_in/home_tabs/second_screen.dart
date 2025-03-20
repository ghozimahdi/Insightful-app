import 'package:flutter/material.dart';

import '../../../util/theme.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: theme.textTheme.titleMedium,
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: const Center(
        child: Text('Welcome to the Second Screen!'),
      ),
    );
  }
}
