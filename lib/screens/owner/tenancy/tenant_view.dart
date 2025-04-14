import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/tenant_model.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class TenantViewPage extends StatefulWidget {
  final int tenantId;

  const TenantViewPage({super.key, required this.tenantId});

  @override
  State<TenantViewPage> createState() => _TenantViewPageState();
}

class _TenantViewPageState extends State<TenantViewPage> {
  late Future<Tenant> tenantDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    tenantDetails = fetchTenantDetails(widget.tenantId);
  }

  Future<Tenant> fetchTenantDetails(int tenantId) async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().get(
        '${ApiService.baseUrl}/owner/tenant-details/$tenantId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data['success']) {
        return Tenant.fromJson(response.data['data']);
      }
      throw Exception(
        response.data['message'] ?? 'Failed to load tenant details',
      );
    } catch (e) {
      debugPrint('Error fetching tenant details: $e');
      throw Exception('Failed to load tenant information');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tenant Details",
          style: TextStyle(color: BackgroundColor.button),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: BackgroundColor.bgcolor,
      body: FutureBuilder<Tenant>(
        future: tenantDetails,
        builder: (context, snapshot) {
          if (_isLoading) {
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
                  const Text(
                    "Failed to load tenant details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        tenantDetails = fetchTenantDetails(widget.tenantId);
                      });
                    },
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              "assets/images/user3.jpg",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "${tenant.firstName} ${tenant.lastName}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: BackgroundColor.button,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tenant.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tenant Details
                _buildDetailCard("Contact Number", tenant.contact, Icons.phone),
                _buildDetailCard("NID Number", tenant.nid, Icons.credit_card),
                _buildDetailCard("Occupation", tenant.occupation, Icons.work),
                _buildDetailCard(
                  "Permanent Address",
                  tenant.address,
                  Icons.home,
                ),
                _buildDetailCard(
                  "Registration Date",
                  tenant.createdAt.split('T')[0],
                  Icons.calendar_today,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
