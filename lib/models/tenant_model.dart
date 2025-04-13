class Tenant {
  final String firstName;
  final String lastName;
  final String email;
  final String contact;
  final String nid;
  final String occupation;
  final String address;
  final String createdAt;

  Tenant({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contact,
    required this.nid,
    required this.occupation,
    required this.address,
    required this.createdAt,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['user_email'] ?? '',
      contact: json['contact_number'] ?? '',
      nid: json['nid'].toString(),
      occupation: json['occupation'] ?? '',
      address: json['permanent_address'] ?? '',
      createdAt: json['creation_date'].toString(),
    );
  }
}
