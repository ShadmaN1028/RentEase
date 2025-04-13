class PaymentInfo {
  final String buildingName;
  final String address;
  final String flatNumber;
  final int flatsId;
  final double rent;
  final double totalPaid;

  PaymentInfo({
    required this.buildingName,
    required this.address,
    required this.flatNumber,
    required this.flatsId,
    required this.rent,
    required this.totalPaid,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      buildingName: json['building_name'] ?? '',
      address: json['address'] ?? '',
      flatNumber: json['flat_number'] ?? '',
      flatsId: json['flats_id'],
      rent: double.tryParse(json['rent'].toString()) ?? 0,
      totalPaid: double.tryParse(json['total_paid'].toString()) ?? 0,
    );
  }

  double get amountLeft => rent - totalPaid;
}
