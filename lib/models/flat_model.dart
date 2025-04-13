class Flat {
  final int flatsId;
  final String flatNumber;
  final String area;
  final int rooms;
  final int bath;
  final int balcony;
  final String description;
  final int status;
  final String rent;
  final int tenancyType;
  final String buildingName;
  final String? address;

  Flat({
    required this.flatsId,
    required this.flatNumber,
    required this.area,
    required this.rooms,
    required this.bath,
    required this.balcony,
    required this.description,
    required this.status,
    required this.rent,
    required this.tenancyType,
    required this.buildingName,
    this.address,
  });

  factory Flat.fromJson(Map<String, dynamic> json) {
    return Flat(
      flatsId: json['flats_id'],
      flatNumber: json['flat_number'],
      area: json['area'].toString(),
      rooms: json['rooms'],
      bath: json['bath'],
      balcony: json['balcony'],
      description: json['description'],
      status: json['status'] ?? 0,
      rent: json['rent'].toString(),
      tenancyType: json['tenancy_type'],
      buildingName: json['building_name'],
      address: json.containsKey('address') ? json['address'] : null,
    );
  }
}
