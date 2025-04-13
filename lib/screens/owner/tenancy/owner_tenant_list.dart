import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/tenant_card.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/owner/tenancy/tenant_details.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class OwnerTenantList extends StatefulWidget {
  const OwnerTenantList({super.key});

  @override
  State<OwnerTenantList> createState() => _OwnerTenantListState();
}

class _OwnerTenantListState extends State<OwnerTenantList> {
  late Future<List<TenantCardModel>> tenantList;

  @override
  void initState() {
    super.initState();
    tenantList = fetchTenants();
  }

  Future<List<TenantCardModel>> fetchTenants() async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await Dio().get(
      '${ApiService.baseUrl}/owner/tenancy/tenancy-list',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    final data = response.data['data'] as List;
    return data.map((json) => TenantCardModel.fromJson(json)).toList();
  }

  Future<void> removeTenant(int tenancyId) async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().put(
        '${ApiService.baseUrl}/owner/tenancy/remove-tenancy/$tenancyId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tenant removed successfully")),
        );
        setState(() {
          tenantList = fetchTenants();
        });
      } else {
        throw Exception("Failed to remove tenant");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to remove tenant")));
    }
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  removeTenant(tenancyId);
                },
                child: const Text("Yes, Remove"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      appBar: AppBar(title: const Text("Tenant List")),
      body: FutureBuilder<List<TenantCardModel>>(
        future: tenantList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No tenants available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final tenant = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tenant: ${tenant.tenantName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Building: ${tenant.buildingName}"),
                      Text("Flat: ${tenant.flatNumber}"),
                      Text("Address: ${tenant.address}"),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TenantDetailsPage(
                                        tenancyId: tenant.tenancyId,
                                      ),
                                ),
                              );
                            },
                            child: const Text("View Tenant"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                            ),
                            onPressed: () => confirmRemove(tenant.tenancyId),
                            child: Text(
                              "Kick Tenant",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
