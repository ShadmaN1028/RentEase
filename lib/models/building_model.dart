class Building {
  final int buildingId;
  final String buildingName;
  final String address;
  final int vacantFlats;
  final int parking;

  Building({
    required this.buildingId,
    required this.buildingName,
    required this.address,
    required this.vacantFlats,
    required this.parking,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      buildingId: json['building_id'] ?? 0,
      buildingName: json['building_name'] ?? '',
      address: json['address'],
      vacantFlats: json['vacant_flats'],
      parking: json['parking'],
    );
  }
}
