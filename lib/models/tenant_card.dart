class TenantCardModel {
  final int tenancyId;
  final String tenantName;
  final String buildingName;
  final String flatNumber;
  final String address;

  TenantCardModel({
    required this.tenancyId,
    required this.tenantName,
    required this.buildingName,
    required this.flatNumber,
    required this.address,
  });

  factory TenantCardModel.fromJson(Map<String, dynamic> json) {
    return TenantCardModel(
      tenancyId: json['tenancy_id'],
      tenantName: "${json['first_name']} ${json['last_name']}",
      buildingName: json['building_name'],
      flatNumber: json['flat_number'],
      address: json['address'],
    );
  }
}
