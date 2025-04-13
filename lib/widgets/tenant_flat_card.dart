import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rentease/models/flat_model.dart';
import 'package:rentease/screens/tenant/flat/flat_details_page.dart';
import 'package:rentease/utils/constants.dart';

class TenantFlatCard extends StatelessWidget {
  final Flat flat;
  static const String defaultImagePath = 'assets/images/flat3.jpeg';

  const TenantFlatCard({super.key, required this.flat});

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
                // Flat Number
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
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Available",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Room, Bath, Balcony, Tenancy
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.bedDouble,
                          size: 16,
                          color: BackgroundColor.textlight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${flat.rooms} ${flat.rooms == 1 || flat.rooms == 0 ? 'room' : 'rooms'}',
                          style: TextStyle(color: BackgroundColor.textlight),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.bath,
                          size: 16,
                          color: BackgroundColor.textlight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${flat.bath} ${flat.bath == 1 || flat.bath == 0 ? 'bath' : 'baths'}',
                          style: TextStyle(color: BackgroundColor.textlight),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                  ],
                ),
                const SizedBox(height: 16),

                // Rent
                Text(
                  'BDT ৳${flat.rent}/Month',
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

                // View Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FlatDetailsPage(flatId: flat.flatsId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BackgroundColor.button2,
                    foregroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('View'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
