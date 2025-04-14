import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/application_model.dart';
import 'package:rentease/utils/constants.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/widgets/application_card_tenant.dart';

class TenantApplicationsPage extends StatefulWidget {
  const TenantApplicationsPage({super.key});

  @override
  State<TenantApplicationsPage> createState() => _TenantApplicationsPageState();
}

class _TenantApplicationsPageState extends State<TenantApplicationsPage> {
  List<Application> applications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().get(
        '${ApiService.baseUrl}/tenant/check-applications',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200 && response.data['success']) {
        final List<dynamic> data = response.data['data'];
        setState(() {
          applications = data.map((e) => Application.fromJson(e)).toList();
        });
      } else {
        throw Exception('Failed to fetch applications');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      appBar: AppBar(
        title: Text(
          "My Applications",
          style: TextStyle(color: BackgroundColor.button),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: BackgroundColor.button),
        backgroundColor: BackgroundColor.bgcolor,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : applications.isEmpty
              ? const Center(child: Text("No applications found"))
              : ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  return ApplicationCardTenant(app: applications[index]);
                },
              ),
    );
  }
}
