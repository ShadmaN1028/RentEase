import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/building_model.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/owner/building/add_building.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/widgets/building_card.dart';
import 'package:rentease/utils/constants.dart';

class OwnerSearch extends StatefulWidget {
  const OwnerSearch({super.key});

  @override
  State<OwnerSearch> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerSearch> {
  List<Building> buildings = [];
  List<Building> filteredBuildings = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBuildings();
    _searchController.addListener(() {
      filterBuildings();
    });
  }

  void filterBuildings() {
    final search = _searchController.text.toLowerCase();
    setState(() {
      filteredBuildings =
          buildings.where((b) {
            return b.buildingName.toLowerCase().contains(search) ||
                b.address.toLowerCase().contains(search);
          }).toList();
    });
  }

  Future<void> fetchBuildings() async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final apiService = ApiService();
      final response = await apiService.dio.get(
        '${ApiService.baseUrl}/owner/buildings',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> buildingsJson = response.data['data'];
        final fetchedBuildings =
            buildingsJson.map((b) => Building.fromJson(b)).toList();
        setState(() {
          _isLoading = false;
          filteredBuildings = fetchedBuildings;
          buildings = fetchedBuildings;
        });
      } else {
        throw Exception(
          "Failed to fetch buildings: ${response.data['message']}",
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching buildings: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      // appBar: AppBar(
      //   title: const Text("Owner Dashboard"),
      //   backgroundColor: BackgroundColor.bgcolor,
      //   foregroundColor: BackgroundColor.textbold,
      // ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: "Search buildings...",
                        labelStyle: TextStyle(
                          color: BackgroundColor.textinput,
                        ), // Set label text color
                        prefixIcon: Icon(
                          Icons.search,
                          color: BackgroundColor.textinput,
                        ), // Set icon color
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.teal,
                      ), // Set input text color
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          filteredBuildings.isNotEmpty
                              ? ListView.builder(
                                itemCount: filteredBuildings.length,
                                itemBuilder: (context, index) {
                                  final building = filteredBuildings[index];
                                  return BuildingCard(
                                    building: building,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/building-detail/${building.buildingId}',
                                      );
                                    },
                                  );
                                },
                              )
                              : const Center(
                                child: Text("No buildings found."),
                              ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddBuildingPage();
              },
            ),
          );
        },
        backgroundColor: BackgroundColor.textlight,
        label: Text("Add Building", style: TextStyle(color: Colors.grey[100])),
        icon: Icon(Icons.add, color: Colors.grey[100]),
      ),
    );
  }
}
