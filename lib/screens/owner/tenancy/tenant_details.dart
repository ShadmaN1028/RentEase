import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/tenant_details.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/owner/owner_homepage.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class TenantDetailsPage extends StatefulWidget {
  final int tenancyId;
  const TenantDetailsPage({super.key, required this.tenancyId});

  @override
  State<TenantDetailsPage> createState() => _TenantDetailsPageState();
}

class _TenantDetailsPageState extends State<TenantDetailsPage> {
  late Future<TenantDetailsModel> tenantDetails;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    tenantDetails = fetchTenantDetails(widget.tenancyId);
  }

  Future<TenantDetailsModel> fetchTenantDetails(int tenancyId) async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;

      final response = await Dio().get(
        '${ApiService.baseUrl}/owner/tenancy/tenancy-details/$tenancyId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true &&
          response.data['data'] != null) {
        final List dataList = response.data['data'];
        if (dataList.isNotEmpty) {
          return TenantDetailsModel.fromJson(dataList[0]);
        }
        throw Exception("Empty data list");
      }
      throw Exception(response.data['message'] ?? "Unexpected response");
    } on DioException catch (e) {
      throw Exception("Failed to load tenant details: ${e.message}");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      color: BackgroundColor.bgcolor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.blueGrey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void confirmRemove(int tenancyId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Remove Tenant"),
            content: const Text(
              "Are you sure you want to remove this tenant? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return OwnerHomepage();
                      },
                    ),
                  );
                  removeTenant(tenancyId);
                },
                child: const Text("Yes, Remove"),
              ),
            ],
          ),
    );
  }

  Future<void> removeTenant(int tenancyId) async {
    setState(() => _isProcessing = true);
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().put(
        '${ApiService.baseUrl}/owner/tenancy/remove-tenancy/$tenancyId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tenant removed successfully"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        throw Exception("Failed to remove tenant");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to remove tenant"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      appBar: AppBar(
        title: const Text("Tenant Details"),
        backgroundColor: BackgroundColor.bgcolor,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<TenantDetailsModel>(
        future: tenantDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: BackgroundColor.bgcolor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading tenant details",
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => setState(() {
                          tenantDetails = fetchTenantDetails(widget.tenancyId);
                        }),
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No tenant data available",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final tenant = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Tenant Profile Section
                Card(
                  elevation: 0,
                  color: BackgroundColor.bgcolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/user2.jpg",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "${tenant.firstName} ${tenant.lastName}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tenant.userEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tenant Details Section
                _buildDetailCard(
                  "Contact Number",
                  tenant.contactNumber,
                  Icons.phone,
                ),
                _buildDetailCard(
                  "NID Number",
                  tenant.nid.toString(),
                  Icons.credit_card,
                ),
                _buildDetailCard(
                  "Permanent Address",
                  tenant.permanentAddress,
                  Icons.home,
                ),
                _buildDetailCard(
                  "Flat Number",
                  tenant.flatNumber,
                  Icons.apartment,
                ),

                // Kick Tenant Button
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _isProcessing
                            ? null
                            : () => confirmRemove(widget.tenancyId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.shade200, width: 1),
                      ),
                    ),
                    child:
                        _isProcessing
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                            : const Text(
                              "Kick Tenant",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
