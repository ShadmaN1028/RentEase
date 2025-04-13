import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rentease/utils/constants.dart';

class TenantNotf extends StatelessWidget {
  const TenantNotf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/helloBot.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'Tenant Notification page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
