import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/flat_model.dart';
import 'package:rentease/utils/constants.dart';
import 'package:rentease/widgets/flat_card.dart';
import 'package:dio/dio.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'add_flat.dart'; // Import your add flat page here

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

  Future<void> deleteFlat(int flatId) async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final response = await ApiService().dio.delete(
        '${ApiService.baseUrl}/owner/flats/$flatId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success']) {
        setState(() {
          flats.removeWhere((flat) => flat.flatsId == flatId);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Flat deleted successfully")));
      } else {
        throw Exception("Failed to delete flat");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting flat: $e")));
    }
  }

  Future<void> _showDeleteConfirmationDialog(int flatId) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Are you sure you want to delete this flat?"),
            content: Text("This action can't be undone."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmDelete ?? false) {
      await deleteFlat(flatId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Flats',
            style: TextStyle(color: BackgroundColor.button2),
          ),
        ),
        backgroundColor: BackgroundColor.bgcolor,
        iconTheme: IconThemeData(color: BackgroundColor.button2),
      ),
      backgroundColor: BackgroundColor.bgcolor,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : flats.isEmpty
              ? const Center(child: Text("No flats available"))
              : ListView.builder(
                itemCount: flats.length,
                itemBuilder: (context, index) {
                  final flat = flats[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          label: 'Delete Flat',
                          backgroundColor: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                          autoClose: true,
                          icon: Icons.delete,
                          onPressed:
                              (_) =>
                                  _showDeleteConfirmationDialog(flat.flatsId),
                        ),
                      ],
                    ),
                    child: FlatCard(flat: flat, buildingId: widget.buildingId),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFlat(buildingId: widget.buildingId),
            ),
          ).then((_) => fetchFlats()); // Refresh flats after adding
        },
        backgroundColor: BackgroundColor.textlight,
        label: Text("Add Flat", style: TextStyle(color: Colors.grey[100])),
        icon: Icon(Icons.add, color: Colors.grey[100]),
      ),
    );
  }
}
