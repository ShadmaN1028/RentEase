class PaymentInfoOwner {
  final int tenancyId;
  final String firstName;
  final String lastName;
  final String flatNumber;
  final String rent;
  final String totalPaid;
  final String amountLeft;
  final String paymentStatus;

  PaymentInfoOwner({
    required this.tenancyId,
    required this.firstName,
    required this.lastName,
    required this.flatNumber,
    required this.rent,
    required this.totalPaid,
    required this.amountLeft,
    required this.paymentStatus,
  });

  factory PaymentInfoOwner.fromJson(Map<String, dynamic> json) {
    return PaymentInfoOwner(
      tenancyId: json['tenancy_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      flatNumber: json['flat_number'],
      rent: json['rent'].toString(),
      totalPaid: json['total_paid'].toString(),
      amountLeft: json['amount_left'].toString(),
      paymentStatus: json['payment_status'],
    );
  }
}
