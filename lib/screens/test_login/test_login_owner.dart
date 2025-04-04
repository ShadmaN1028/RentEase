import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TestLoginScreenOwner extends StatelessWidget {
  const TestLoginScreenOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Owner Login')),
      body: Center(
        child: Lottie.asset(
          'assets/lotties/helloBot.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
