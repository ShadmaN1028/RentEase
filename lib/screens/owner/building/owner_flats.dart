import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/flat_model.dart';
import 'package:rentease/widgets/flat_card.dart';
import 'package:dio/dio.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';

class OwnerFlats extends StatefulWidget {
  final int buildingId;
  const OwnerFlats({super.key, required this.buildingId});

  @override
  State<OwnerFlats> createState() => _OwnerFlatsPageState();
}

class _OwnerFlatsPageState extends State<OwnerFlats> {
  List<Flat> flats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFlats();
  }

  Future<void> fetchFlats() async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final response = await ApiService().dio.get(
        '${ApiService.baseUrl}/owner/flats-list/${widget.buildingId}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;
      if (data['success'] && data['data'] is List) {
        setState(() {
          flats =
              (data['data'] as List)
                  .map((json) => Flat.fromJson(json))
                  .toList();
        });
      }
    } catch (e) {
      print("Error fetching flats: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flats")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : flats.isEmpty
              ? const Center(child: Text("No flats available"))
              : ListView.builder(
                itemCount: flats.length,
                itemBuilder:
                    (context, index) => FlatCard(
                      flat: flats[index],
                      onTap: () {
                        // You can navigate to a flat detail page or perform any action
                      },
                    ),
              ),
    );
  }
}
