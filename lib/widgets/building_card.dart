import 'package:flutter/material.dart';
import 'package:rentease/models/building_model.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rentease/utils/constants.dart'; // Import Lucide icons

class BuildingCard extends StatelessWidget {
  final Building building;
  final VoidCallback onTap;

  const BuildingCard({super.key, required this.building, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[100], // Card background color (gray 100)
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Building name with a Lucide icon
              Row(
                children: [
                  Icon(
                    LucideIcons.building,
                    color: BackgroundColor.button2,
                  ), // Building icon
                  const SizedBox(width: 8),
                  Text(
                    building.buildingName,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: BackgroundColor.button2, // Text color set to teal
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Address with location icon
              Row(
                children: [
                  Icon(
                    LucideIcons.mapPin,
                    color: BackgroundColor.button2,
                  ), // Location icon
                  const SizedBox(width: 8),
                  Text(
                    "Address: ${building.address}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: BackgroundColor.button2, // Text color set to teal
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Vacant flats information with icon
              Row(
                children: [
                  Icon(
                    LucideIcons.home,
                    color: BackgroundColor.button2,
                  ), // Flats icon
                  const SizedBox(width: 8),
                  Text(
                    "Vacant Flats: ${building.vacantFlats}",
                    style: TextStyle(
                      fontSize: 18,
                      color: BackgroundColor.button2, // Text color set to teal
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Parking availability with icon
              Row(
                children: [
                  Icon(
                    LucideIcons.car,
                    color: BackgroundColor.button2,
                  ), // Parking icon
                  const SizedBox(width: 8),
                  Text(
                    "Parking: ${building.parking > 0 ? 'Available' : 'Unavailable'}",
                    style: TextStyle(
                      fontSize: 18,
                      color: BackgroundColor.button2, // Text color set to teal
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
