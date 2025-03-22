import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RentEase')),
      body: Center(child: Lottie.asset('assets/lotties/error.json')),
    );
  }
}
