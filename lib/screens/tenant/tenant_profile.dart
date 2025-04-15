import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/tenant/tenant_change_password.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';
import 'package:dio/dio.dart';

class TenantProfile extends StatefulWidget {
  const TenantProfile({super.key});

  @override
  State<TenantProfile> createState() => _TenantProfilePageState();
}

class _TenantProfilePageState extends State<TenantProfile> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nidController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _occupationController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTenantProfile();
  }

  Future<void> fetchTenantProfile() async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      print(token);
      final apiService = ApiService();
      final response = await apiService.dio.get(
        '${ApiService.baseUrl}/tenant/user-info',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data['data'];
      print(data);
      _firstNameController.text = data['first_name'] ?? '';
      _lastNameController.text = data['last_name'] ?? '';
      _nidController.text = data['nid']?.toString() ?? '';
      _emailController.text = data['user_email'] ?? '';
      _addressController.text = data['permanent_address'] ?? '';
      _contactController.text = data['contact_number'] ?? '';
      _occupationController.text = data['occupation'] ?? '';
    } catch (e) {
      print('Failed to fetch tenant profile: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load profile')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: BackgroundColor.textinput),
        prefixIcon: Icon(Icons.edit, color: BackgroundColor.textinput),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      style: TextStyle(color: BackgroundColor.textinput),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Widget _buildNonEditableField(
    String label,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: BackgroundColor.textinput),
        prefixIcon: Icon(Icons.lock, color: BackgroundColor.textinput),
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      style: TextStyle(color: Colors.grey.shade600),
    );
  }

  Future<void> updateProfile() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unauthorized: No token found")));
      return;
    }

    try {
      final apiService = ApiService();
      final response = await apiService.dio.put(
        '${ApiService.baseUrl}/tenant/update-info',
        data: {
          "first_name": _firstNameController.text.trim(),
          "last_name": _lastNameController.text.trim(),
          "nid":
              _nidController.text
                  .trim(), // optional if disabled but included in body
          "permanent_address": _addressController.text.trim(),
          "contact_number": _contactController.text.trim(),
          "occupation": _occupationController.text.trim(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile updated successfully")));
      } else {
        throw Exception("Update failed");
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating profile")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: BackgroundColor.textbold),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button2),
      ),
      backgroundColor: BackgroundColor.bgcolor,
      body: SafeArea(
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "Tenant Profile",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: BackgroundColor.textbold,
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildEditableField("First Name", _firstNameController),
                        SizedBox(height: 15),
                        _buildEditableField("Last Name", _lastNameController),
                        SizedBox(height: 15),
                        _buildNonEditableField("NID", _nidController),
                        SizedBox(height: 15),
                        _buildNonEditableField("Email", _emailController),
                        SizedBox(height: 15),
                        _buildEditableField("Address", _addressController),
                        SizedBox(height: 15),
                        _buildEditableField(
                          "Contact Number",
                          _contactController,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 15),
                        _buildEditableField(
                          "Occupation",
                          _occupationController,
                        ),
                        SizedBox(height: 25),

                        // Save Changes Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BackgroundColor.button,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Save Changes",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Change Password Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return TenantChangePassword();
                                  },
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: BackgroundColor.button2!,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              "Change Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: BackgroundColor.button2,
                                fontWeight: FontWeight.w600,
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
