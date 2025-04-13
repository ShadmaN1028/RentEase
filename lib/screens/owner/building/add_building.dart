import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/utils/constants.dart';
import 'package:rentease/widgets/widget_tree.dart';

class AddBuildingPage extends StatefulWidget {
  const AddBuildingPage({super.key});

  @override
  State<AddBuildingPage> createState() => _AddBuildingPageState();
}

class _AddBuildingPageState extends State<AddBuildingPage> {
  final _formKey = GlobalKey<FormState>();
  final _buildingNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _vacantFlatsController = TextEditingController();
  int _parking = 0; // 0 for unavailable, 1 for available
  bool _isLoading = false;

  Future<void> _addBuilding() async {
    if (!_formKey.currentState!.validate()) return;

    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unauthorized: No token found")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.dio.post(
        '${ApiService.baseUrl}/owner/add-building',
        data: {
          'building_name': _buildingNameController.text.trim(),
          'address': _addressController.text.trim(),
          'vacant_flats': int.parse(_vacantFlatsController.text.trim()),
          'parking': _parking.toString(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Building added successfully")),
        );

        // Redirect to OwnerSearchPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WidgetTree();
            },
          ),
        );
      } else {
        throw Exception("Failed to add building");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error adding building: $e")));
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
          'Add Building',
          style: TextStyle(color: BackgroundColor.button2),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(
          color: BackgroundColor.button2,
        ), // Set back button color to teal
      ),
      backgroundColor: BackgroundColor.bgcolor, // Set background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _buildingNameController,
                decoration: InputDecoration(
                  labelText: 'Building Name',
                  prefixIcon: Icon(Icons.home, color: BackgroundColor.button2),
                  filled: true,
                  fillColor: Colors.grey[100], // Fill with grey[100]
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                  ),
                  labelStyle: TextStyle(color: BackgroundColor.button2),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the building name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: BackgroundColor.button2,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                  ),
                  labelStyle: TextStyle(color: BackgroundColor.button2),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vacantFlatsController,
                decoration: InputDecoration(
                  labelText: 'Vacant Flats',
                  prefixIcon: Icon(
                    Icons.business,
                    color: BackgroundColor.button2,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                  ),
                  labelStyle: TextStyle(color: BackgroundColor.button2),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of vacant flats';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _parking,
                decoration: InputDecoration(
                  labelText: 'Parking Available',
                  prefixIcon: Icon(
                    Icons.directions_car,
                    color: BackgroundColor.button2,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                  ),
                  labelStyle: TextStyle(color: BackgroundColor.button2),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Available')),
                  DropdownMenuItem(value: 0, child: Text('Unavailable')),
                ],
                onChanged: (value) {
                  setState(() {
                    _parking = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select parking availability';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _addBuilding,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.grey[100])
                        : Text(
                          'Add Building',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[100],
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
