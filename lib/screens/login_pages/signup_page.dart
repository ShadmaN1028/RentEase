import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentease/data/constants.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/login_pages/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool isOwner = true; // Default to Owner

  // Controllers for TextFormFields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).setToNull();
    });
  }

  @override
  void dispose() {
    // Dispose controllers
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _addressController.clear();
    _nidController.clear();
    _occupationController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button2),
      ),
      backgroundColor: BackgroundColor.bgcolor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Join RentEase!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: BackgroundColor.textbold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Sign up to get started",
                        style: TextStyle(
                          fontSize: 18,
                          color: BackgroundColor.textlight,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Choose User Type",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal[800],
                          ),
                        ),
                        Spacer(),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return SegmentedButton<bool>(
                              showSelectedIcon: false,
                              style: ButtonStyle(
                                side: WidgetStateProperty.all(
                                  BorderSide(
                                    color: Colors.teal[700]!,
                                    width: 1,
                                  ),
                                ),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return Colors.teal[700]!;
                                      }
                                      return Colors.white;
                                    }),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
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
                                ).isOwner,
                              },
                              onSelectionChanged: (Set<bool> newSelection) {
                                // setState(() {
                                //   isOwner = newSelection.first;
                                // });
                                Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                ).setOwner(newSelection.first);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // First Name Field
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: "First Name",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        prefixIcon: Icon(
                          Icons.person,
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
                        if (value!.isEmpty) {
                          return "First name is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    // Last Name Field
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        prefixIcon: Icon(
                          Icons.person,
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
                        if (value!.isEmpty) {
                          return "Last name is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    // Email Field
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    // Password Field
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: authProvider.showPassword,
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
                                authProvider.showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: BackgroundColor.textinput,
                              ),
                              onTap: () {
                                authProvider.setShowPassword(
                                  !authProvider.showPassword,
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
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    // Phone Field
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: BackgroundColor.textinput,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(213, 113, 114, 1),
                            width: 2,
                          ),
                        ),
                        // focusedErrorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(15),
                        //   borderSide: BorderSide(color: Colors.red, width: 2),
                        // ),
                      ),
                      style: TextStyle(color: BackgroundColor.textinput),
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone number is required";
                        } else if (value.length != 11) {
                          return "Phone number must be 11 digits";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    // Address Field
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        prefixIcon: Icon(
                          Icons.home,
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
                        if (value!.isEmpty) {
                          return "Address is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    // NID Field
                    TextFormField(
                      controller: _nidController,
                      decoration: InputDecoration(
                        labelText: "NID No",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        prefixIcon: Icon(
                          Icons.credit_card,
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "NID is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    // Occupation Field
                    TextFormField(
                      controller: _occupationController,
                      decoration: InputDecoration(
                        labelText: "Occupation",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        prefixIcon: Icon(
                          Icons.work,
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
                        if (value!.isEmpty) {
                          return "Must provide an occupation";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                          if (_formKey.currentState!.validate()) {
                            print("First Name: ${_firstNameController.text}");
                            print("Last Name: ${_lastNameController.text}");
                            print("Email: ${_emailController.text}");
                            print("Password: ${_passwordController.text}");
                            print("Phone: ${_phoneController.text}");
                            print("Address: ${_addressController.text}");
                            print("NID: ${_nidController.text}");
                            print("Occupation: ${_occupationController.text}");
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.teal[800]),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginPage();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Login",
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
}
