import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/building_model.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/owner/building/add_building.dart';
import 'package:rentease/screens/owner/building/edit_building.dart';
// import 'package:rentease/screens/owner/building/edit_building.dart'; // Import edit page
import 'package:rentease/screens/owner/building/owner_flats.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/widgets/building_card.dart';
import 'package:rentease/utils/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OwnerSearch extends StatefulWidget {
  const OwnerSearch({super.key});

  @override
  State<OwnerSearch> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerSearch> {
  List<Building> buildings = [];
  List<Building> filteredBuildings = [];
  // ignore: prefer_final_fields
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

  // Function to handle delete confirmation
  void _showDeleteConfirmation(Building building) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            "This will also delete all the flats data of this Building. This action can't be undone.",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteBuilding(building.buildingId); // Call delete function
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Function to call the API to delete the building
  Future<void> _deleteBuilding(int buildingId) async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final apiService = ApiService();
      final response = await apiService.dio.delete(
        '${ApiService.baseUrl}/owner/building/$buildingId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          buildings.removeWhere(
            (building) => building.buildingId == buildingId,
          );
          filteredBuildings.removeWhere(
            (building) => building.buildingId == buildingId,
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Building deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete building')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting building: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
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
                        labelStyle: TextStyle(color: BackgroundColor.textinput),
                        prefixIcon: Icon(
                          Icons.search,
                          color: BackgroundColor.textinput,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.teal),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          filteredBuildings.isNotEmpty
                              ? ListView.builder(
                                itemCount: filteredBuildings.length,
                                itemBuilder: (context, index) {
                                  final building = filteredBuildings[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ), // Add spacing between cards
                                    child: Slidable(
                                      key: ValueKey(building.buildingId),
                                      startActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              // Navigate to edit page
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          EditBuildingPage(
                                                            building: building,
                                                          ),
                                                ),
                                              );
                                            },
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                            label: 'Edit\nBuilding',
                                            autoClose: true,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            // Rounded corners
                                          ),
                                        ],
                                      ),
                                      endActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              _showDeleteConfirmation(building);
                                            },
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete\nBuilding',
                                            autoClose: true,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ), // Rounded corners
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ), // Match card's rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: BuildingCard(
                                          building: building,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => OwnerFlats(
                                                      buildingId:
                                                          building.buildingId,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
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
        label: const Text("", style: TextStyle(color: Colors.white)),
        icon: Image.asset(
          "assets/images/house.png",
          height: 24,
          width: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
