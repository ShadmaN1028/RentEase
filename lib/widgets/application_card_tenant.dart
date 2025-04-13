import 'package:flutter/material.dart';
import 'package:rentease/models/application_model.dart';
import 'package:rentease/screens/tenant/flat/flat_details_page.dart';
import 'package:rentease/utils/constants.dart';

class ApplicationCardTenant extends StatelessWidget {
  final Application app;

  const ApplicationCardTenant({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final String statusText =
        app.status == 1
            ? "Accepted"
            : app.status == 2
            ? "Rejected"
            : "Pending";
    final Color statusColor =
        app.status == 1
            ? Colors.green
            : app.status == 2
            ? Colors.red
            : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
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
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(statusText),
                  backgroundColor: statusColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: statusColor),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FlatDetailsPage(flatId: app.flatsId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BackgroundColor.button2,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("View Flat"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
