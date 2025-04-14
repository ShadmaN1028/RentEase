class TenantNotification {
  final int notificationId;
  final String description;
  final int status; // 0 = unread, 1 = read
  final String creationDate;

  TenantNotification({
    required this.notificationId,
    required this.description,
    required this.status,
    required this.creationDate,
  });

  factory TenantNotification.fromJson(Map<String, dynamic> json) {
    return TenantNotification(
      notificationId: json['notification_id'],
      description: json['description'],
      status: json['status'],
      creationDate: json['creation_date'],
    );
  }
}
