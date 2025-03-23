import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rentease/data/constants.dart';
import 'package:rentease/screens/login_pages/signup_page.dart';

class WelcomeNewuserPage extends StatelessWidget {
  const WelcomeNewuserPage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button2),
      ),
      backgroundColor: BackgroundColor.bgcolor,
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
                    color: BackgroundColor.textbold,
                  ),
                ),
                SizedBox(height: 20),
                FittedBox(
                  child: Text(
                    '"Where renting meets innovation"',
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 20,
                      color: BackgroundColor.textlight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignupPage();
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: BackgroundColor.button,
                  ),
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
