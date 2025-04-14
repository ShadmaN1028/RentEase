import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/service_request.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';

class OwnerServiceRequestPage extends StatefulWidget {
  const OwnerServiceRequestPage({super.key});

  @override
  State<OwnerServiceRequestPage> createState() =>
      _OwnerServiceRequestPageState();
}

class _OwnerServiceRequestPageState extends State<OwnerServiceRequestPage> {
  late Future<List<ServiceRequestModel>> requestList;

  @override
  void initState() {
    super.initState();
    requestList = fetchRequests();
  }

  Future<List<ServiceRequestModel>> fetchRequests() async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    final res = await Dio().get(
      '${ApiService.baseUrl}/owner/pending-request',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = res.data['data'] as List;
    return data.map((e) => ServiceRequestModel.fromJson(e)).toList();
  }

  Future<void> handleAction(String type, int requestId) async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    final url = '${ApiService.baseUrl}/owner/${type}-request/$requestId';

    try {
      final res = await Dio().post(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (res.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request ${type}d successfully")),
        );
        setState(() {
          requestList = fetchRequests(); // Refresh list
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to $type request")));
    }
  }

  String getRequestTypeLabel(int type) {
    switch (type) {
      case 0:
        return "Maintenance";
      case 1:
        return "Repair";
      case 2:
        return "Other";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pending Requests")),
      body: FutureBuilder<List<ServiceRequestModel>>(
        future: requestList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No pending requests"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final request = snapshot.data![index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getRequestTypeLabel(request.requestType),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(request.description),
                      const SizedBox(height: 8),
                      Text(
                        "Submitted: ${request.creationDate.split('T')[0]}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed:
                                () =>
                                    handleAction('approve', request.requestId),
                            child: const Text("Approve"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed:
                                () => handleAction('deny', request.requestId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text(
                              "Deny",
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
