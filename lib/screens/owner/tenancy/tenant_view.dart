import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/tenant_model.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';

class TenantViewPage extends StatefulWidget {
  final int tenantId;

  const TenantViewPage({super.key, required this.tenantId});

  @override
  State<TenantViewPage> createState() => _TenantViewPageState();
}

class _TenantViewPageState extends State<TenantViewPage> {
  late Future<Tenant> tenantDetails;

  @override
  void initState() {
    super.initState();
    tenantDetails = fetchTenantDetails(widget.tenantId);
  }

  Future<Tenant> fetchTenantDetails(int tenantId) async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await Dio().get(
      '${ApiService.baseUrl}/owner/tenant-details/$tenantId',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200 && response.data['success']) {
      return Tenant.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load tenant details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tenant Info")),
      body: FutureBuilder<Tenant>(
        future: tenantDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data found"));
          }

          final tenant = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${tenant.firstName} ${tenant.lastName}"),
                Text("Email: ${tenant.email}"),
                Text("Contact: ${tenant.contact}"),
                Text("NID: ${tenant.nid}"),
                Text("Occupation: ${tenant.occupation}"),
                Text("Address: ${tenant.address}"),
                Text("Registered On: ${tenant.createdAt.split('T')[0]}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
