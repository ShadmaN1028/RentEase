import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/service_request.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/tenant/service_request/service_request_tenant.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class TenantRequestListPage extends StatefulWidget {
  const TenantRequestListPage({super.key});

  @override
  State<TenantRequestListPage> createState() => _TenantRequestListPageState();
}

class _TenantRequestListPageState extends State<TenantRequestListPage> {
  late Future<List<ServiceRequestModel>> _requests;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _requests = fetchRequests();
  }

  Future<List<ServiceRequestModel>> fetchRequests() async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().get(
        '${ApiService.baseUrl}/tenant/check-requests',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true &&
          response.data['data'] != null) {
        final List dataList = response.data['data'];
        return dataList
            .map((json) => ServiceRequestModel.fromJson(json))
            .toList();
      }
      throw Exception(response.data['message'] ?? "Failed to fetch requests");
    } catch (e) {
      debugPrint("Error fetching requests: $e");
      throw Exception("Failed to load service requests");
    }
  }

  Future<void> _refreshRequests() async {
    setState(() => _isRefreshing = true);
    try {
      setState(() {
        _requests = fetchRequests();
      });
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  String getRequestType(int type) {
    switch (type) {
      case 0:
        return 'Maintenance';
      case 1:
        return 'Repair';
      case 2:
        return 'Other';
      default:
        return 'Service Request';
    }
  }

  IconData getRequestIcon(int type) {
    switch (type) {
      case 0:
        return Icons.handyman;
      case 1:
        return Icons.home_repair_service;
      case 2:
        return Icons.help_outline;
      default:
        return Icons.question_mark;
    }
  }

  Color getStatusColor(int status) {
    return status == 1 ? Colors.green.shade400 : Colors.orange.shade400;
  }

  String getStatusLabel(int status) {
    return status == 1 ? 'Resolved' : 'Pending';
  }

  Widget _buildRequestCard(ServiceRequestModel request) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Add navigation to request details if needed
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    getRequestIcon(request.requestType),
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      getRequestType(request.requestType),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      getStatusLabel(request.status),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: getStatusColor(request.status),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                request.description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Submitted: ${request.creationDate.split('T')[0]}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Service Requests",
          style: TextStyle(color: BackgroundColor.button),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button),
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshRequests,
        color: BackgroundColor.bgcolor,
        child: FutureBuilder<List<ServiceRequestModel>>(
          future: _requests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !_isRefreshing) {
              return Center(
                child: CircularProgressIndicator(
                  color: BackgroundColor.bgcolor,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Failed to load requests",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshRequests,
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No Service Requests",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You haven't submitted any service requests yet",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final request = snapshot.data![index];
                return _buildRequestCard(request);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TenantServiceRequestPage(),
            ),
          ).then((_) {
            // Refresh list when returning from creating a new request
            _refreshRequests();
          });
        },
        backgroundColor: BackgroundColor.button,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
