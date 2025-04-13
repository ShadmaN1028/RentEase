class Application {
  final int flatsId;
  final String flatNumber;
  final String rent;
  final int rooms;
  final int bath;
  final int balcony;
  final String area;
  final int tenancyType;
  final String? description; // nullable
  final String buildingName;
  final int status;

  Application({
    required this.flatsId,
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

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      flatsId: json['flats_id'],
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
