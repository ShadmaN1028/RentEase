import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rentease/models/flat_model.dart';
import 'package:rentease/screens/owner/building/owner_flats.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/providers/auth_provider.dart';

class EditFlat extends StatefulWidget {
  final Flat flat;
  final int buildingId;
  const EditFlat({super.key, required this.flat, required this.buildingId});

  @override
  State<EditFlat> createState() => _EditFlatPageState();
}

class _EditFlatPageState extends State<EditFlat> {
  late TextEditingController _flatNumberController;
  late TextEditingController _areaController;
  late TextEditingController _roomsController;
  late TextEditingController _bathController;
  late TextEditingController _balconyController;
  late TextEditingController _descriptionController;
  late TextEditingController _rentController;

  int _status = 1;
  int _tenancyType = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _flatNumberController = TextEditingController(text: widget.flat.flatNumber);
    _areaController = TextEditingController(text: widget.flat.area.toString());
    _roomsController = TextEditingController(
      text: widget.flat.rooms.toString(),
    );
    _bathController = TextEditingController(text: widget.flat.bath.toString());
    _balconyController = TextEditingController(
      text: widget.flat.balcony.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.flat.description,
    );
    _rentController = TextEditingController(text: widget.flat.rent.toString());
    _status = widget.flat.status;
    _tenancyType = widget.flat.tenancyType;
  }

  Future<void> updateFlat() async {
    setState(() => _isLoading = true);
    String? token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final response = await ApiService().dio.put(
        '${ApiService.baseUrl}/owner/flats/${widget.flat.flatsId}',
        data: {
          'flat_number': _flatNumberController.text,
          'area': _areaController.text,
          'rooms': _roomsController.text,
          'bath': _bathController.text,
          'balcony': _balconyController.text,
          'description': _descriptionController.text,
          'status': _status.toString(),
          'rent': _rentController.text,
          'tenancy_type': _tenancyType,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Flat updated successfully")),
        );
        // Redirect to OwnerFlatsPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return OwnerFlats(buildingId: widget.buildingId);
            },
          ),
        );
      } else {
        throw Exception("Failed to update flat");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating flat: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Center(
          child: Text(
            "Edit Flat",
            style: TextStyle(color: BackgroundColor.textbold),
          ),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              _flatNumberController,
              'Flat Number',
              TextInputType.text,
            ),
            _buildTextField(
              _areaController,
              'Area (sq ft)',
              TextInputType.number,
            ),
            _buildTextField(_roomsController, 'Rooms', TextInputType.number),
            _buildTextField(_bathController, 'Bathrooms', TextInputType.number),
            _buildTextField(
              _balconyController,
              'Balconies',
              TextInputType.number,
            ),
            _buildTextField(_rentController, 'Rent', TextInputType.number),
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: Colors.white,
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
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _status,
              decoration: InputDecoration(
                labelText: 'Tenancy Status',
                prefixIcon: Icon(
                  LucideIcons.doorOpen,
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
                DropdownMenuItem(value: 0, child: Text("Vacant")),
                DropdownMenuItem(value: 1, child: Text("Occupied")),
              ],
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 32),
            DropdownButtonFormField<int>(
              value: _tenancyType,
              decoration: InputDecoration(
                labelText: 'Tenancy Type',
                prefixIcon: Icon(
                  LucideIcons.users,
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
                DropdownMenuItem(value: 1, child: Text("Bachelor")),
                DropdownMenuItem(value: 2, child: Text("Family")),
              ],
              onChanged: (value) => setState(() => _tenancyType = value!),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : updateFlat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BackgroundColor.button,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ),
            const SizedBox(height: 16),
            // Add the Go Back Button here
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Go back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Go Back",
                  style: TextStyle(color: BackgroundColor.button2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType inputType,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
    );
  }
}
