import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeNewuserPage extends StatelessWidget {
  const WelcomeNewuserPage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Lottie.asset('assets/lotties/home.json', height: 400),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to RentEase',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 5),
                FittedBox(
                  child: Text(
                    'Where renting meets innovation',
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 20,
                      color: Colors.white54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // FilledButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) {
                //           //return LoginPage(title: 'Login');
                //         },
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: Size(double.infinity, 50),
                //   ),
                //   child: Text('Register'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
