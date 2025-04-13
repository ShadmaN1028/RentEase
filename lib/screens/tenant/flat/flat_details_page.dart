import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/flat_model.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class FlatDetailsPage extends StatefulWidget {
  final int flatId;

  const FlatDetailsPage({Key? key, required this.flatId}) : super(key: key);

  @override
  _FlatDetailsPageState createState() => _FlatDetailsPageState();
}

class _FlatDetailsPageState extends State<FlatDetailsPage> {
  late Future<Flat> flatDetails;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    flatDetails = fetchFlatDetails(widget.flatId);

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<Flat> fetchFlatDetails(int flatId) async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await Dio().get(
        '${ApiService.baseUrl}/tenant/flat-details/$flatId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data['data'];
        if (dataList.isNotEmpty) {
          return Flat.fromJson(dataList[0]);
        } else {
          throw Exception('No flat details found');
        }
      } else {
        throw Exception('Failed to load flat details');
      }
    } catch (e) {
      throw Exception('Error fetching flat details: $e');
    }
  }

  Future<void> applyForFlat(BuildContext context, int flatId) async {
    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;

      final response = await Dio().post(
        '${ApiService.baseUrl}/tenant/make-applications/$flatId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.data['message'])));
      } else {
        // Show popup for known errors
        String errorMessage = response.data['message'] ?? 'Failed to apply';
        _showPopup(context, errorMessage);
      }
    } catch (e) {
      // Handle DioError or other exceptions gracefully
      if (e is DioError && e.response != null) {
        final message = e.response?.data['message'] ?? 'Something went wrong';
        _showPopup(context, message);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
      }
    }
  }

  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Alert"),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      body: FutureBuilder<Flat>(
        future: flatDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final flat = snapshot.data!;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: 300,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              children: [
                                Image.asset(
                                  'assets/images/bed1.jpg',
                                  fit: BoxFit.cover,
                                ),
                                Image.asset(
                                  'assets/images/bed2.jpg',
                                  fit: BoxFit.cover,
                                ),
                                Image.asset(
                                  'assets/images/flat2.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: _currentPage == index ? 12 : 8,
                                  height: _currentPage == index ? 12 : 8,
                                  decoration: BoxDecoration(
                                    color:
                                        _currentPage == index
                                            ? Colors.white
                                            : Colors.white54,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "৳${flat.rent}/Month",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (flat.address != null &&
                                flat.address!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  flat.address!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),

                            // First Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _iconText(
                                  Icons.bed,
                                  "${flat.rooms} ${flat.rooms == 1 || flat.rooms == 0 ? 'Room' : 'Rooms'}",
                                ),
                                _iconText(
                                  Icons.bathtub,
                                  "${flat.bath} ${flat.bath == 1 || flat.bath == 0 ? 'Bath' : 'Baths'}",
                                ),
                                _iconText(
                                  Icons.air,
                                  "${flat.balcony} ${flat.balcony == 1 || flat.balcony == 0 ? 'Balcony' : 'Balconies'}",
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Second Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _iconText(
                                  Icons.group,
                                  flat.tenancyType == 1 ? "Bachelor" : "Family",
                                ),
                                _iconText(
                                  Icons.square_foot,
                                  "${flat.area} sqft",
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Top Rated & Stars
                            const Text(
                              "#Top Rated",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),
                            const Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              flat.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Back Button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),

                // Apply Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    color: BackgroundColor.bgcolor,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await applyForFlat(context, flat.flatsId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BackgroundColor.button2,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Apply",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
