import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rentease/models/tenant_notf.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class TenantNotificationPage extends StatefulWidget {
  const TenantNotificationPage({super.key});

  @override
  State<TenantNotificationPage> createState() => _TenantNotificationPageState();
}

class _TenantNotificationPageState extends State<TenantNotificationPage> {
  late Future<List<TenantNotification>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = fetchNotifications();
  }

  Future<List<TenantNotification>> fetchNotifications() async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    final res = await Dio().get(
      '${ApiService.baseUrl}/tenant/notifications-list',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = res.data['data'] as List;
    return data.map((e) => TenantNotification.fromJson(e)).toList();
  }

  Future<void> markAsRead(int notificationId) async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      await Dio().put(
        '${ApiService.baseUrl}/tenant/mark-as-read/$notificationId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() {
        notifications = fetchNotifications();
      });
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
      body: FutureBuilder<List<TenantNotification>>(
        future: notifications,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
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
                  subtitle: Text("Date: ${notif.creationDate.split("T")[0]}"),
                  trailing:
                      notif.status == 0
                          ? Icon(
                            Icons.mark_email_unread,
                            color: BackgroundColor.button,
                          )
                          : const Icon(
                            Icons.mark_email_read_outlined,
                            color: Colors.grey,
                          ),
                  onTap: () => markAsRead(notif.notificationId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
