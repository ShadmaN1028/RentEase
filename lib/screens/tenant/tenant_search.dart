import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/flat_model.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';
import 'package:rentease/widgets/tenant_flat_card.dart';

class TenantSearch extends StatefulWidget {
  const TenantSearch({super.key});

  @override
  State<TenantSearch> createState() => _TenantSearchPageState();
}

class _TenantSearchPageState extends State<TenantSearch> {
  List<Flat> flats = [];
  List<Flat> filteredFlats = [];
  bool isLoading = true;

  final TextEditingController roomsController = TextEditingController();
  final TextEditingController bathController = TextEditingController();
  final TextEditingController balconyController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFlats();
  }

  Future<void> fetchFlats() async {
    setState(() => isLoading = true);
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await ApiService().dio.get(
        '${ApiService.baseUrl}/tenant/available-flats',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 && response.data['success']) {
        final List<dynamic> data = response.data['data'];
        print(response.data['data']);

        final fetched = data.map((e) => Flat.fromJson(e)).toList();
        setState(() {
          flats = fetched;
          filteredFlats = fetched;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to fetch flats: ${response.data['message']}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching flats: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSearchPopup() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Search Flats"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _buildField(roomsController, "Rooms"),
                  _buildField(bathController, "Bathrooms"),
                  _buildField(balconyController, "Balcony"),
                  _buildField(areaController, "Area"),
                  // _buildField(addressController, "Address"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  applySearch();
                  Navigator.pop(context);
                },
                child: const Text("Search"),
              ),
              TextButton(
                onPressed: () {
                  resetSearch();
                  Navigator.pop(context);
                },
                child: const Text("Reset"),
              ),
            ],
          ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void applySearch() {
    final room = int.tryParse(roomsController.text.trim());
    final bath = int.tryParse(bathController.text.trim());
    final balcony = int.tryParse(balconyController.text.trim());
    final area = areaController.text.toLowerCase().trim();
    // final address = addressController.text.toLowerCase().trim();

    setState(() {
      filteredFlats =
          flats.where((flat) {
            if (room != null && flat.rooms < room) return false;
            if (bath != null && flat.bath < bath) return false;
            if (balcony != null && flat.balcony < balcony) return false;
            if (area.isNotEmpty && !flat.area.toLowerCase().contains(area))
              return false;
            // if (address.isNotEmpty &&
            //     !flat.address.toLowerCase().contains(address))
            //   return false;
            return true;
          }).toList();
    });
  }

  void resetSearch() {
    roomsController.clear();
    bathController.clear();
    balconyController.clear();
    areaController.clear();
    addressController.clear();
    setState(() => filteredFlats = flats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: showSearchPopup,
                        icon: const Icon(Icons.search),
                        label: const Text("Search Flats"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BackgroundColor.button2,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child:
                        filteredFlats.isEmpty
                            ? const Center(
                              child: Text("No matching flats found."),
                            )
                            : ListView.builder(
                              itemCount: filteredFlats.length,
                              itemBuilder: (context, index) {
                                final flat = filteredFlats[index];
                                return TenantFlatCard(flat: flat);
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
