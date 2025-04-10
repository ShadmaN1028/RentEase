import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rentease/models/flat_model.dart';
import 'package:rentease/screens/owner/building/edit_flat.dart';
import 'package:rentease/utils/constants.dart';

class FlatCard extends StatelessWidget {
  final Flat flat;
  static const String defaultImagePath = 'assets/images/flat3.jpeg';
  final int buildingId;

  const FlatCard({super.key, required this.flat, required this.buildingId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              defaultImagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flat Number and Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      flat.flatNumber,
                      style: TextStyle(
                        color: BackgroundColor.button2,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            flat.status == 0
                                ? Colors.red[50]
                                : Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        flat.status == 0 ? 'Vacant' : 'Rented',
                        style: TextStyle(
                          color: flat.status == 0 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Icons: Room, Bath, Balcony, Tenancy Type
                Row(
                  children: [
                    Icon(
                      LucideIcons.bedDouble,
                      size: 16,
                      color: BackgroundColor.textlight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${flat.rooms} ${flat.rooms == 1 ? 'room' : 'rooms'}',
                      style: TextStyle(color: BackgroundColor.textlight),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      LucideIcons.bath,
                      size: 16,
                      color: BackgroundColor.textlight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${flat.bath} ${flat.bath == 1 ? 'bath' : 'baths'}',
                      style: TextStyle(color: BackgroundColor.textlight),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      LucideIcons.wind,
                      size: 16,
                      color: BackgroundColor.textlight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${flat.balcony} ${flat.balcony == 1 ? 'balcony' : 'balconies'}',
                      style: TextStyle(color: BackgroundColor.textlight),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      LucideIcons.users,
                      size: 16,
                      color: BackgroundColor.textlight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      flat.tenancyType == 1 ? 'Bachelor' : 'Family',
                      style: TextStyle(color: BackgroundColor.textlight),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Rent
                Text(
                  'BDT  ৳${flat.rent}/Month',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: BackgroundColor.textbold,
                  ),
                ),

                const SizedBox(height: 8),

                // Area
                Row(
                  children: [
                    Icon(
                      LucideIcons.map,
                      size: 16,
                      color: BackgroundColor.textlight,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${flat.area} sqft",
                        style: TextStyle(color: BackgroundColor.textlight),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Edit Button
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                EditFlat(flat: flat, buildingId: buildingId),
                      ),
                    );
                    if (result == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Flat updated successfully"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BackgroundColor.button2,
                    foregroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
