class OwnerApplication {
  final int applicationId; // Only used by owner
  final int flatsId;
  final String flatNumber;
  final int tenantId; // Only used by owner
  final String rent;
  final int rooms;
  final int bath;
  final int balcony;
  final String area;
  final int tenancyType;
  final String? description; // nullable
  final String buildingName;
  final int status;

  OwnerApplication({
    required this.applicationId,
    required this.flatsId,
    required this.tenantId,
    required this.flatNumber,
    required this.rent,
    required this.rooms,
    required this.bath,
    required this.balcony,
    required this.area,
    required this.tenancyType,
    this.description, // not required
    required this.buildingName,
    required this.status,
  });

  factory OwnerApplication.fromJson(Map<String, dynamic> json) {
    return OwnerApplication(
      applicationId: json['applications_id'], // optional
      flatsId: json['flats_id'],
      tenantId: json['user_id'], // optional
      flatNumber: json['flat_number'],
      rent: json['rent'].toString(), // just in case rent is numeric
      rooms: json['rooms'] ?? 0,
      bath: json['bath'] ?? 0,
      balcony: json['balcony'] ?? 0,
      area: json['area'].toString(),
      tenancyType: json['tenancy_type'] ?? 0,
      description: json['description'], // may be null
      buildingName: json['building_name'],
      status: json['status'] ?? 0,
    );
  }
}
