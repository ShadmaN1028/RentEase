class ServiceRequestModel {
  final int requestId;
  final int requestType;
  final String description;
  final int status;
  final String creationDate;

  ServiceRequestModel({
    required this.requestId,
    required this.requestType,
    required this.description,
    required this.status,
    required this.creationDate,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      requestId: json['request_id'],
      requestType: json['request_type'],
      description: json['description'],
      status: json['status'],
      creationDate: json['creation_date'],
    );
  }
}
