import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rentease/screens/login_pages/login_page.dart';
import 'package:rentease/screens/welcome_screen/welcome_newuser_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //lotties animation for the Landing page
                Lottie.asset('assets/lotties/home.json', height: 400),
                SizedBox(height: 100),
                FittedBox(
                  child: Text(
                    'RentEase',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      letterSpacing: 50,
                      color: Colors.teal,
                    ),
                  ),
                ),
                SizedBox(height: 100),
                FilledButton(
                  //button to navigate to the info page about the app
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return WelcomeNewuserPage();
                        },
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor:
                        Colors.teal[700], // Set button color to teal[700]
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                    ), // Ensure text is visible
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  //button to navigate to the login page who already registered
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginPage();
                        },
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor:
                        Colors.white, // Set button color to teal[700]
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.teal[700],
                    ), // Ensure text is visible
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
