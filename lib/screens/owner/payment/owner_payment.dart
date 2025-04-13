import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/payment_info_owner.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class OwnerPaymentOverviewPage extends StatefulWidget {
  const OwnerPaymentOverviewPage({super.key});

  @override
  State<OwnerPaymentOverviewPage> createState() =>
      _OwnerPaymentOverviewPageState();
}

class _OwnerPaymentOverviewPageState extends State<OwnerPaymentOverviewPage> {
  late Future<List<PaymentInfoOwner>> _paymentOverview;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _paymentOverview = fetchPayments();
  }

  Future<List<PaymentInfoOwner>> fetchPayments() async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final res = await Dio().get(
        '${ApiService.baseUrl}/owner/payment-overview',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (res.data['success'] == true) {
        final List data = res.data['data'];
        return data.map((e) => PaymentInfoOwner.fromJson(e)).toList();
      }
      throw Exception(res.data['message'] ?? 'Failed to load payments');
    } catch (e) {
      debugPrint('Error fetching payments: $e');
      throw Exception('Failed to load payment data');
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    try {
      setState(() {
        _paymentOverview = fetchPayments();
      });
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'partially paid':
        return Colors.orange;
      case 'due':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle;
      case 'partially paid':
        return Icons.warning;
      case 'due':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Widget _buildPaymentCard(PaymentInfoOwner payment) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  getStatusIcon(payment.paymentStatus),
                  color: getStatusColor(payment.paymentStatus),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${payment.firstName} ${payment.lastName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    payment.paymentStatus,
                    style: TextStyle(
                      color: getStatusColor(payment.paymentStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: getStatusColor(
                    payment.paymentStatus,
                  ).withOpacity(0.1),
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPaymentDetailRow("Flat Number", payment.flatNumber),
            const Divider(height: 16),
            _buildPaymentDetailRow("Monthly Rent", "৳${payment.rent}"),
            const Divider(height: 16),
            _buildPaymentDetailRow("Amount Paid", "৳${payment.totalPaid}"),
            const Divider(height: 16),
            _buildPaymentDetailRow(
              "Remaining Due",
              "৳${payment.amountLeft}",
              isHighlighted: double.parse(payment.amountLeft) > 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isHighlighted ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tenant Payments Overview"),
        backgroundColor: BackgroundColor.bgcolor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: BackgroundColor.bgcolor,
        child: FutureBuilder<List<PaymentInfoOwner>>(
          future: _paymentOverview,
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
                      "Failed to load payments",
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
                      onPressed: _refreshData,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No Payment Records",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You don't have any payment records yet",
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
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final payment = snapshot.data![index];
                return _buildPaymentCard(payment);
              },
            );
          },
        ),
      ),
    );
  }
}
