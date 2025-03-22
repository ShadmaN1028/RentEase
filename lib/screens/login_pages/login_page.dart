import 'package:flutter/material.dart';
import 'package:rentease/data/constants.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(
          color: Colors.teal[800],
        ), // Set the back button color to teal
      ),
      backgroundColor: Colors.teal[50], // Light teal background for a soft look
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
                      color: Colors.teal[800],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Subtitle Text
                Center(
                  child: Text(
                    "Login to continue",
                    style: TextStyle(fontSize: 18, color: Colors.teal[600]),
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
                    onPressed: () {}, // TODO: Implement Forgot Password
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
                      backgroundColor: Colors.teal[700],
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
                          // TODO: Navigate to Signup Page
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
