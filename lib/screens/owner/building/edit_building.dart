import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/building_model.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/utils/constants.dart';
import 'package:rentease/widgets/widget_tree.dart';

class EditBuildingPage extends StatefulWidget {
  final Building building;

  const EditBuildingPage({super.key, required this.building});

  @override
  State<EditBuildingPage> createState() => _EditBuildingPageState();
}

class _EditBuildingPageState extends State<EditBuildingPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _buildingNameController;
  late TextEditingController _addressController;
  late TextEditingController _vacantFlatsController;
  int _parking = 0; // 0 for unavailable, 1 for available
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _buildingNameController = TextEditingController(
      text: widget.building.buildingName,
    );
    _addressController = TextEditingController(text: widget.building.address);
    _vacantFlatsController = TextEditingController(
      text: widget.building.vacantFlats.toString(),
    );
    _parking = widget.building.parking;
  }

  Future<void> _editBuilding() async {
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
      final response = await apiService.dio.put(
        '${ApiService.baseUrl}/owner/building/${widget.building.buildingId}',
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
          const SnackBar(content: Text("Building updated successfully")),
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
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unauthorized: Invalid token")),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bad Request: Invalid input data")),
        );
      } else {
        throw Exception("Failed to update building");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating building: $e")));
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
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Edit Building',
            style: TextStyle(color: BackgroundColor.button2),
          ),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button2),
      ),
      backgroundColor: BackgroundColor.bgcolor,
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
                onPressed: _isLoading ? null : _editBuilding,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BackgroundColor.button,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.grey[100])
                        : Text(
                          'Update Building',
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
