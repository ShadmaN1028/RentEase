import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:dio/dio.dart';
import 'package:rentease/utils/constants.dart';

class AddFlat extends StatefulWidget {
  final int buildingId;
  const AddFlat({super.key, required this.buildingId});

  @override
  State<AddFlat> createState() => _AddFlatPageState();
}

class _AddFlatPageState extends State<AddFlat> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathController = TextEditingController();
  final TextEditingController _balconyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();

  int status = 0; // 0 - vacant, 1 - occupied
  int tenancyType = 1; // 1 - family, 2 - bachelor
  bool _isLoading = false;

  Future<void> addFlat() async {
    if (!_formKey.currentState!.validate()) return;

    String? token = Provider.of<AuthProvider>(context, listen: false).token;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService().dio.post(
        '${ApiService.baseUrl}/owner/add-flat/${widget.buildingId}',
        data: {
          "flat_number": _flatNumberController.text.trim(),
          "area": _areaController.text.trim(),
          "rooms": _roomsController.text.trim(),
          "bath": _bathController.text.trim(),
          "balcony": _balconyController.text.trim(),
          "description": _descriptionController.text.trim(),
          "status": status.toString(),
          "rent": _rentController.text.trim(),
          "tenancy_type": tenancyType,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Flat added successfully")));
        Navigator.pop(context);
      } else {
        throw Exception("Failed to add flat");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Flat",
          style: TextStyle(color: BackgroundColor.button2),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button2),
      ),
      backgroundColor: BackgroundColor.bgcolor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("Flat Number", _flatNumberController),
              buildTextField(
                "Area (sq ft)",
                _areaController,
                keyboard: TextInputType.number,
              ),
              buildTextField(
                "Rooms",
                _roomsController,
                keyboard: TextInputType.number,
              ),
              buildTextField(
                "Bathrooms",
                _bathController,
                keyboard: TextInputType.number,
              ),
              buildTextField(
                "Balconies",
                _balconyController,
                keyboard: TextInputType.number,
              ),
              buildTextField(
                "Rent/Month",
                _rentController,
                keyboard: TextInputType.number,
              ),
              buildTextField(
                "Description",
                _descriptionController,
                maxLines: 3,
              ),

              const SizedBox(height: 10),
              buildDropdown("Status", ["Vacant", "Occupied"], (val) {
                setState(() => status = val == "Occupied" ? 1 : 0);
              }),
              buildDropdown("Tenancy Type", ["Family", "Bachelor"], (val) {
                setState(() => tenancyType = val == "Bachelor" ? 1 : 2);
              }),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : addFlat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BackgroundColor.button,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Add Flat",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: BackgroundColor.textinput),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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

  Widget buildDropdown(
    String label,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        value: items[0],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: BackgroundColor.textinput),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
        ),
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: (val) => onChanged(val!),
      ),
    );
  }
}
