class TenancyInfo {
  final String flatNumber;
  final String buildingName;
  final String address;
  final String area;
  final int rooms;
  final int bath;
  final int balcony;
  final String startDate;
  final String ownerFirstName;
  final String ownerLastName;
  final String contact;
  final String? description;
  final int flatsId;

  TenancyInfo({
    required this.flatNumber,
    required this.buildingName,
    required this.address,
    required this.area,
    required this.rooms,
    required this.bath,
    required this.balcony,
    required this.startDate,
    required this.ownerFirstName,
    required this.ownerLastName,
    required this.contact,
    this.description,
    required this.flatsId,
  });

  factory TenancyInfo.fromJson(Map<String, dynamic> json) {
    return TenancyInfo(
      flatNumber: json['flat_number'] ?? '',
      buildingName: json['building_name'] ?? '',
      address: json['address'] ?? '',
      area: json['area'].toString(),
      rooms: json['rooms'] ?? 0,
      bath: json['bath'] ?? 0,
      balcony: json['balcony'] ?? 0,
      startDate: json['start_date'] ?? '',
      ownerFirstName: json['first_name'] ?? '',
      ownerLastName: json['last_name'] ?? '',
      contact: json['contact_number'] ?? '',
      description: json['description'],
      flatsId: json['flats_id'],
    );
  }
}
