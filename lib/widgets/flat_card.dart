import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rentease/models/flat_model.dart';

class FlatCard extends StatelessWidget {
  final Flat flat;
  final VoidCallback? onTap;

  const FlatCard({super.key, required this.flat, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: flat.status == 1 ? Colors.green.shade50 : Colors.yellow.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Flat ${flat.flatNumber}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 16),
                  const SizedBox(width: 8),
                  Text("${flat.area} sq ft"),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.home, size: 16),
                  const SizedBox(width: 8),
                  Text("${flat.rooms} room(s)"),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.bath, size: 16),
                  const SizedBox(width: 8),
                  Text("${flat.bath} bathroom(s)"),
                ],
              ),
              if (flat.balcony > 0)
                Row(
                  children: [
                    const Icon(LucideIcons.wind, size: 16),
                    const SizedBox(width: 8),
                    Text("${flat.balcony} balcony(s)"),
                  ],
                ),
              Row(
                children: [
                  const Icon(LucideIcons.dollarSign, size: 16),
                  const SizedBox(width: 8),
                  Text("\$${flat.rent}/month"),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.bedDouble, size: 16),
                  const SizedBox(width: 8),
                  Text(flat.tenancyType == 1 ? "Family" : "Bachelor"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
