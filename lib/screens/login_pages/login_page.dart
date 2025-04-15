import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentease/utils/constants.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/login_pages/reset_password.dart';
import 'package:rentease/screens/login_pages/signup_page.dart';
import 'package:rentease/widgets/widget_tree.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isOwner = true; // Default to Owner Login

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).setToNullLogin();
      // _emailController.text = "tenant1@tenant.com";
      // _passwordController.text = "12345678";
    });
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return SegmentedButton<bool>(
                            showSelectedIcon: false,
                            style: ButtonStyle(
                              side: WidgetStateProperty.all(
                                BorderSide(color: Colors.teal[700]!, width: 1),
                              ),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.teal[700]!;
                                    }
                                    return Colors.white;
                                  }),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.white;
                                    }
                                    return Colors.teal[700]!;
                                  }),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            segments: const <ButtonSegment<bool>>[
                              ButtonSegment<bool>(
                                value: true,

                                label: Text('Owner'),
                              ),
                              ButtonSegment<bool>(
                                value: false,
                                label: Text('Tenant'),
                              ),
                            ],
                            selected: {
                              Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).isLoginOwner,
                            },
                            onSelectionChanged: (Set<bool> newSelection) {
                              // setState(() {
                              //   isOwner = newSelection.first;
                              // });
                              Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).setLoginOwner(newSelection.first);
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    // Email Input Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        prefixIcon: Icon(
                          Icons.email,
                          color: BackgroundColor.textinput,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(213, 113, 114, 1),
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: BackgroundColor.textinput),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Password Input Field
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: authProvider.showPasswordLogin,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: BackgroundColor.textinput,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: BackgroundColor.textinput,
                            ),
                            suffixIcon: InkWell(
                              child: Icon(
                                authProvider.showPasswordLogin
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: BackgroundColor.textinput,
                              ),
                              onTap: () {
                                authProvider.setShowPasswordLogin(
                                  !authProvider.showPasswordLogin,
                                );
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(213, 113, 114, 1),
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: BackgroundColor.textinput),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password is required";
                            } else if (value.length < 8) {
                              return "Password must be at least 8 characters long";
                            }
                            return null;
                          },
                        );
                      },
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
                        onPressed: () async {
                          login();
                        },
                        child:
                            Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                ).isLoadingLogin
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
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
                              Navigator.pushReplacement(
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
        ),
      ),
    );
  }

  Future<void> login() async {
    {
      if (_formKey.currentState!.validate()) {
        String email = _emailController.text;
        String password = _passwordController.text;

        AuthProvider authProvider = Provider.of<AuthProvider>(
          context,
          listen: false,
        );

        bool isLoggedIn = await authProvider.login(email, password);

        if (isLoggedIn) {
          // Navigate to home or dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return WidgetTree();
              },
            ),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? "Login failed"),
            ),
          );
        }
      }
    }
  }
}
