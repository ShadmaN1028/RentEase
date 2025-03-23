import 'package:flutter/material.dart';
import 'package:rentease/data/constants.dart';
import 'package:rentease/screens/login_pages/reset_password.dart';
import 'package:rentease/screens/login_pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isOwner = true; // Default to Owner Login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(
          color: BackgroundColor.button2,
        ), // Set the back button color to teal
      ),
      backgroundColor: BackgroundColor.bgcolor, // Light teal background
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Text
                Center(
                  child: Text(
                    "Manage your rentals!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: BackgroundColor.textbold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Subtitle Text
                Center(
                  child: Text(
                    "Login to continue",
                    style: TextStyle(
                      fontSize: 18,
                      color: BackgroundColor.textlight,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                //check owner and tenant
                Center(
                  child: SegmentedButton<bool>(
                    segments: const <ButtonSegment<bool>>[
                      ButtonSegment<bool>(value: true, label: Text('Owner')),
                      ButtonSegment<bool>(value: false, label: Text('Tenant')),
                    ],
                    selected: {isOwner},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setState(() {
                        isOwner =
                            newSelection
                                .first; // Update isOwner with the new selected value
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),
                // Email Input Field
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.teal[700]),
                    prefixIcon: Icon(Icons.email, color: Colors.teal[700]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Password Input Field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.teal[700]),
                    prefixIcon: Icon(Icons.lock, color: Colors.teal[700]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Forgot Password Option
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ResetPassword();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.teal[700]),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BackgroundColor.button,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Implement Login Logic
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Signup Option
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.teal[800]),
                      ),
                      TextButton(
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
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[700],
                          ),
                        ),
                      ),
                    ],
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
