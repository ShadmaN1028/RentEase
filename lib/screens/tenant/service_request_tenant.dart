import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceRequestTenant extends StatefulWidget {
  @override
  _ServiceRequestScreenState createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestTenant> {
  final TextEditingController _requestTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final String apiUrl =
      "https://your-api-url.com/tenant/make-requests"; // Replace with your API URL
  bool _isLoading = false;

  Future<void> makeServiceRequest(
    String flatId,
    String requestType,
    String description,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/$flatId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN', // Replace with your token logic
        },
        body: jsonEncode({
          'request_type': requestType,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request submitted successfully')),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(responseData['message'])));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit request')));
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Service Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _requestTypeController,
              decoration: InputDecoration(labelText: 'Request Type'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () {
                    final requestType = _requestTypeController.text.trim();
                    final description = _descriptionController.text.trim();
                    const flatId = "123"; // Replace with actual flat ID
                    if (requestType.isNotEmpty && description.isNotEmpty) {
                      makeServiceRequest(flatId, requestType, description);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('All fields are required')),
                      );
                    }
                  },
                  child: Text('Submit Request'),
                ),
          ],
        ),
      ),
    );
  }
}
