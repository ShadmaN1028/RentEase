import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/tenancy_info.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';
import 'package:rentease/widgets/widget_tree.dart';

class MyFlat extends StatefulWidget {
  const MyFlat({super.key});

  @override
  State<MyFlat> createState() => _TenantFlatInfoPageState();
}

class _TenantFlatInfoPageState extends State<MyFlat> {
  late Future<TenancyInfo?> tenancyInfo;

  @override
  void initState() {
    super.initState();
    tenancyInfo = fetchTenancyInfo();
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
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<void> leaveTenancy() async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      final response = await Dio().delete(
        '${ApiService.baseUrl}/tenant/leave-tenancy',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You have left the tenancy successfully"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/tenant/dashboard',
          (route) => false,
        );
      } else {
        throw Exception(response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint("Leave Tenancy Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error leaving tenancy"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void confirmLeaveTenancy() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm Leave"),
            content: const Text(
              "Are you sure you want to leave this tenancy?\nThis action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WidgetTree();
                      },
                    ),
                  );
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  leaveTenancy();
                },
                child: const Text("Yes, Leave"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Flat Details",
          style: TextStyle(color: BackgroundColor.button),
        ),
        iconTheme: IconThemeData(color: BackgroundColor.button),
        backgroundColor: BackgroundColor.bgcolor,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: BackgroundColor.bgcolor,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You are not currently in any tenancy",
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
                // Property Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.apartment,
                              size: 28,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "${flat.buildingName} - Flat ${flat.flatNumber}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: BackgroundColor.button,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailSection(context, "Property Details", [
                          _infoRow(Icons.location_on, flat.address),
                          _infoRow(Icons.bed, "${flat.rooms} rooms"),
                          _infoRow(Icons.bathtub, "${flat.bath} baths"),
                          if (flat.balcony > 0)
                            _infoRow(Icons.balcony, "${flat.balcony} balcony"),
                          _infoRow(Icons.square_foot, "${flat.area} sq ft"),
                          _infoRow(
                            Icons.calendar_month,
                            "Move-in: ${flat.startDate.split('T')[0]}",
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Owner Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildDetailSection(context, "Owner Information", [
                      _infoRow(
                        Icons.person,
                        "${flat.ownerFirstName} ${flat.ownerLastName}",
                      ),
                      _infoRow(Icons.phone, flat.contact),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Card
                if (flat.description != null && flat.description!.isNotEmpty)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: _buildDetailSection(context, "Description", [
                        Text(
                          flat.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ]),
                    ),
                  ),
                const SizedBox(height: 20),

                // Leave Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: confirmLeaveTenancy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.shade200, width: 1),
                      ),
                    ),
                    child: const Text(
                      "Leave Tenancy",
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

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}
