import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/owner_notf.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class OwnerNotificationPage extends StatefulWidget {
  const OwnerNotificationPage({super.key});

  @override
  State<OwnerNotificationPage> createState() => _OwnerNotificationPageState();
}

class _OwnerNotificationPageState extends State<OwnerNotificationPage> {
  late Future<List<OwnerNotification>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = fetchNotifications();
  }

  Future<List<OwnerNotification>> fetchNotifications() async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    final res = await Dio().get(
      '${ApiService.baseUrl}/owner/notifications-list',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = res.data['data'] as List;
    return data.map((e) => OwnerNotification.fromJson(e)).toList();
  }

  Future<void> markAsRead(int notificationId) async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      final response = await Dio().put(
        '${ApiService.baseUrl}/owner/mark-as-read/$notificationId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        setState(() {
          notifications = fetchNotifications();
        });
      } else {
        debugPrint("Mark as read failed: ${response.data['message']}");
      }
    } catch (e) {
      debugPrint("Mark as read error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to mark as read")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,
      body: FutureBuilder<List<OwnerNotification>>(
        future: notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint("Error: ${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notifications"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final notif = snapshot.data![index];
              return Card(
                shape:
                    notif.status == 0
                        ? RoundedRectangleBorder(
                          side: BorderSide(
                            color: BackgroundColor.button!,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        )
                        : null,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    notif.description,
                    style: TextStyle(
                      fontWeight:
                          notif.status == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From: ${notif.firstName} ${notif.lastName}"),
                      Text("Flat: ${notif.flatNumber}"),
                      Text("Date: ${notif.creationDate.split("T")[0]}"),
                    ],
                  ),
                  trailing:
                      notif.status == 0
                          ? Icon(
                            Icons.mark_email_unread,
                            color: BackgroundColor.button,
                          )
                          : Icon(
                            Icons.mark_email_read_outlined,
                            color: Colors.grey,
                          ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (context) =>
                              const Center(child: CircularProgressIndicator()),
                    );
                    await markAsRead(notif.notificationId);
                    Navigator.of(context).pop(); // close dialog
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
