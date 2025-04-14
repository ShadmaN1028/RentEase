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
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    setState(() => isLoading = true);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading applications: ${e.toString()}"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleApplicationAction(int appId, String action) async {
    setState(() => isProcessing = true);
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final endpoint =
          action == 'approve' ? 'approve-application' : 'deny-application';

      final response = await Dio().post(
        '${ApiService.baseUrl}/owner/$endpoint/$appId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Application ${action == 'approve' ? 'approved' : 'denied'}",
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: action == 'approve' ? Colors.green : Colors.orange,
          ),
        );
        await fetchApplications();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      appBar: AppBar(
        title: Text(
          "Pending Applications",
          style: TextStyle(color: BackgroundColor.button),
        ),
        centerTitle: true,
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : fetchApplications,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: BackgroundColor.bgcolor,
                ),
              )
              : applications.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No Pending Applications",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You don't have any applications to review",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: fetchApplications,
                color: BackgroundColor.bgcolor,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: applications.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final app = applications[index];
                    return OwnerApplicationCard(
                      app: app,
                      onAccept: () {
                        if (!isProcessing) {
                          _handleApplicationAction(
                            app.applicationId,
                            'approve',
                          );
                        }
                      },
                      onReject: () {
                        if (!isProcessing) {
                          _handleApplicationAction(app.applicationId, 'deny');
                        }
                      },
                    );
                  },
                ),
              ),
    );
  }
}
