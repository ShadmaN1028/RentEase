import 'package:flutter/material.dart';
import 'package:rentease/models/owner_application_model.dart';
import 'package:rentease/screens/owner/tenancy/tenant_view.dart';
import 'package:rentease/utils/constants.dart';
// import 'package:rentease/screens/tenant_view.dart'; // Import the TenantView page

class OwnerApplicationCard extends StatelessWidget {
  final OwnerApplication app;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const OwnerApplicationCard({
    super.key,
    required this.app,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Flat: ${app.flatNumber}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Building: ${app.buildingName}"),
            Text("Rent: ৳${app.rent}/Month"),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Accept"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Reject"),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TenantViewPage(tenantId: app.tenantId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("View Tenant"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
