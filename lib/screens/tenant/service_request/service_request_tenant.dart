import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/tenancy_info.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/tenant/service_request/tenant_all_request.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class TenantServiceRequestPage extends StatefulWidget {
  const TenantServiceRequestPage({super.key});

  @override
  State<TenantServiceRequestPage> createState() =>
      _TenantServiceRequestPageState();
}

class _TenantServiceRequestPageState extends State<TenantServiceRequestPage> {
  late Future<TenancyInfo?> tenancyInfo;
  String? selectedRequestType;
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> requestTypes = ["Maintenance", "Repair", "Other"];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    tenancyInfo = fetchTenancyInfo();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<TenancyInfo?> fetchTenancyInfo() async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().get(
        '${ApiService.baseUrl}/tenant/get-tenancy-info',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true &&
          response.data['data'] != null) {
        return TenancyInfo.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching tenancy info: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load tenancy information"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }
  }

  Future<void> submitRequest(int flatId) async {
    if (selectedRequestType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a request type"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a description"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().post(
        '${ApiService.baseUrl}/tenant/make-requests/$flatId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {
          "request_type": requestTypes.indexOf(selectedRequestType!),
          "description": _descriptionController.text,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Request submitted successfully"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TenantRequestListPage(),
          ),
        );
      } else {
        throw Exception(response.data['message'] ?? "Failed to submit request");
      }
    } catch (e) {
      debugPrint("Submit Request Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to submit request: ${e.toString()}"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Service Request",
          style: TextStyle(color: BackgroundColor.button),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        elevation: 0,
        iconTheme: IconThemeData(color: BackgroundColor.button),
        centerTitle: true,
      ),
      body: FutureBuilder<TenancyInfo?>(
        future: tenancyInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: BackgroundColor.bgcolor),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.home_work_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No Active Tenancy",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You need to be in a tenancy to submit requests",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          final flat = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Property Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "${flat.buildingName} - Flat ${flat.flatNumber}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Request Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRequestType,
                  hint: const Text("Select Request Type"),
                  items:
                      requestTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() {
                        selectedRequestType = value;
                      }),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  validator:
                      (value) => value == null ? 'Please select a type' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Describe your request in detail...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Please enter a description'
                              : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        _isSubmitting
                            ? null
                            : () => submitRequest(flat.flatsId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BackgroundColor.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _isSubmitting
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              "SUBMIT REQUEST",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
