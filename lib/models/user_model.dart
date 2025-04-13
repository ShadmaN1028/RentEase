class UserModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String nid;
  final String permanentAddress;
  final String contactNumber;
  final String occupation;

  UserModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.nid,
    required this.permanentAddress,
    required this.contactNumber,
    required this.occupation,
  });

  Map<String, dynamic> toJson(bool isOwner) {
    return {
      isOwner ? "owner_email" : "user_email": email,
      isOwner ? "owner_password" : "user_password": password,
      "first_name": firstName,
      "last_name": lastName,
      "nid": nid,
      "permanent_address": permanentAddress,
      "contact_number": contactNumber,
      "occupation": occupation,
    };
  }
}
