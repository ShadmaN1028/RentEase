import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/payment_info.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class TenantPaymentPage extends StatefulWidget {
  const TenantPaymentPage({super.key});

  @override
  State<TenantPaymentPage> createState() => _TenantPaymentPageState();
}

class _TenantPaymentPageState extends State<TenantPaymentPage> {
  late Future<PaymentInfo?> _paymentInfo;
  final TextEditingController _amountController = TextEditingController();
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _paymentInfo = fetchPaymentInfo();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<PaymentInfo?> fetchPaymentInfo() async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final res = await Dio().get(
        '${ApiService.baseUrl}/tenant/payment-info',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (res.data['data'] == null) return null;
      return PaymentInfo.fromJson(res.data['data']);
    } catch (e) {
      debugPrint("Fetch Payment Info Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load payment information"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }
  }

  Future<void> submitPayment() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter an amount"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final res = await Dio().post(
        '${ApiService.baseUrl}/tenant/pay',
        data: {"amount": double.parse(_amountController.text)},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.data['message']),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );

      _amountController.clear();
      setState(() {
        _paymentInfo = fetchPaymentInfo();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment failed. Please try again.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isProcessingPayment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rent Payment",
          style: TextStyle(color: BackgroundColor.button),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: BackgroundColor.button),
      ),
      backgroundColor: BackgroundColor.bgcolor,
      body: FutureBuilder<PaymentInfo?>(
        future: _paymentInfo,
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
                  const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
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
                    "You don't have any payment information",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          final info = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Property Information Card
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
                        Text(
                          "Property Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: BackgroundColor.textbold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.apartment, info.buildingName),
                        _buildInfoRow(Icons.home, "Flat ${info.flatNumber}"),
                        _buildInfoRow(Icons.location_on, info.address),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Payment Summary Card
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
                        Text(
                          "Payment Summary",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: BackgroundColor.textbold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildAmountRow(
                          "Total Rent",
                          "৳${info.rent.toStringAsFixed(2)}",
                          Colors.grey.shade700,
                        ),
                        const Divider(height: 24),
                        _buildAmountRow(
                          "Amount Paid",
                          "৳${info.totalPaid.toStringAsFixed(2)}",
                          Colors.green,
                        ),
                        const Divider(height: 24),
                        _buildAmountRow(
                          "Remaining Rent",
                          "৳${info.amountLeft.toStringAsFixed(2)}",
                          info.amountLeft > 0 ? Colors.orange : Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                info.amountLeft == 0.00
                    ? SizedBox.shrink()
                    :
                    // Payment Form
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "Make Payment",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: BackgroundColor.button,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Amount (BDT)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an amount';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    _isProcessingPayment ? null : submitPayment,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: BackgroundColor.button,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                                child:
                                    _isProcessingPayment
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        )
                                        : Text(
                                          "PAY NOW",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, String amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
