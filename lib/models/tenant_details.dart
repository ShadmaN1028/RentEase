class TenantDetailsModel {
  final String firstName;
  final String lastName;
  final String userEmail;
  final String contactNumber;
  final int nid;
  final String permanentAddress;
  final String flatNumber;

  TenantDetailsModel({
    required this.firstName,
    required this.lastName,
    required this.userEmail,
    required this.contactNumber,
    required this.nid,
    required this.permanentAddress,
    required this.flatNumber,
  });

  factory TenantDetailsModel.fromJson(Map<String, dynamic> json) {
    return TenantDetailsModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      nid: json['nid'] ?? 0,
      permanentAddress: json['permanent_address'] ?? '',
      flatNumber: json['flat_number'] ?? '',
    );
  }
}
