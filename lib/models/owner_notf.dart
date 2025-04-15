class OwnerNotification {
  final int notificationId;
  final String description;
  final String creationDate;
  final int status;
  final String firstName;
  final String lastName;
  final String flatNumber;

  OwnerNotification({
    required this.notificationId,
    required this.description,
    required this.creationDate,
    required this.status,
    required this.firstName,
    required this.lastName,
    required this.flatNumber,
  });

  factory OwnerNotification.fromJson(Map<String, dynamic> json) {
    return OwnerNotification(
      notificationId: json['notification_id'],
      description: json['description'],
      creationDate: json['creation_date'],
      status: json['status'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      flatNumber: json['flat_number'],
    );
  }
}
