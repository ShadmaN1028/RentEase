import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/owner_application_model.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';
import 'package:rentease/widgets/application_card_owner.dart';

class OwnerApplicationsPage extends StatefulWidget {
  const OwnerApplicationsPage({super.key});

  @override
  State<OwnerApplicationsPage> createState() => _OwnerApplicationsPageState();
}

class _OwnerApplicationsPageState extends State<OwnerApplicationsPage> {
  List<OwnerApplication> applications = [];
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
        '${ApiService.baseUrl}/owner/pending-applications',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success']) {
        final List<dynamic> data = response.data['data'];
        setState(() {
          applications = data.map((e) => OwnerApplication.fromJson(e)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> approveApplication(int appId) async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().post(
        '${ApiService.baseUrl}/owner/approve-application/$appId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.data['success']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Application approved")));
        fetchApplications(); // Refresh
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> rejectApplication(int appId) async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().post(
        '${ApiService.baseUrl}/owner/deny-application/$appId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.data['success']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Application denied")));
        fetchApplications(); // Refresh
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      appBar: AppBar(
        title: const Text("Pending Applications"),
        backgroundColor: BackgroundColor.bgcolor,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : applications.isEmpty
              ? const Center(child: Text("No pending applications"))
              : ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  final app = applications[index];
                  return OwnerApplicationCard(
                    app: app,
                    onAccept: () => approveApplication(app.applicationId),
                    onReject: () => rejectApplication(app.applicationId),
                  );
                },
              ),
    );
  }
}
