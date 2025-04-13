import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/utils/constants.dart';

class OwnerChangePassword extends StatefulWidget {
  const OwnerChangePassword({super.key});

  @override
  State<OwnerChangePassword> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<OwnerChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unauthorized: No token found")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      print('Request URL: ${ApiService.baseUrl}/owner/update-password');
      print(
        'Request Data: ${{"currentPassword": _currentPasswordController.text.trim(), "newPassword": _newPasswordController.text.trim()}}',
      );
      final response = await apiService.dio.put(
        '${ApiService.baseUrl}/owner/update-password',
        data: {
          "currentPassword": _currentPasswordController.text.trim(),
          "newPassword": _newPasswordController.text.trim(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password changed successfully")),
        );
        _formKey.currentState!.reset();
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Endpoint not found. Please contact support."),
          ),
        );
        return;
      } else {
        throw Exception("Failed to change password");
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error changing password")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(color: BackgroundColor.textbold),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button2),
      ),
      backgroundColor: BackgroundColor.bgcolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return TextFormField(
                      controller: _currentPasswordController,
                      obscureText: authProvider.showPasswordCurrent,

                      decoration: InputDecoration(
                        labelText: "Current Password",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: InkWell(
                          child: Icon(
                            authProvider.showPasswordCurrent
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: BackgroundColor.textinput,
                          ),
                          onTap: () {
                            authProvider.setShowPasswordCurrent(
                              !authProvider.showPasswordCurrent,
                            );
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: BackgroundColor.textinput,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter current password';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return TextFormField(
                      controller: _newPasswordController,
                      obscureText: authProvider.showPasswordNew1,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),

                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: InkWell(
                          child: Icon(
                            authProvider.showPasswordNew1
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: BackgroundColor.textinput,
                          ),
                          onTap: () {
                            authProvider.setShowPasswordNew1(
                              !authProvider.showPasswordNew1,
                            );
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: BackgroundColor.textinput,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: authProvider.showPasswordNew2,
                      decoration: InputDecoration(
                        labelText: "Confirm New Password",
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: BackgroundColor.textinput,
                        ),
                        suffixIcon: InkWell(
                          child: Icon(
                            authProvider.showPasswordNew2
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: BackgroundColor.textinput,
                          ),
                          onTap: () {
                            authProvider.setShowPasswordNew2(
                              !authProvider.showPasswordNew2,
                            );
                          },
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BackgroundColor.button,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              "Update Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
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
