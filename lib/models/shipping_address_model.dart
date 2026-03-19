class ShippingAddress {
  final String fullName;
  final String phone;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  ShippingAddress({
    required this.fullName,
    required this.phone,
    required this.address1,
    this.address2 = '',
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'phone': phone,
    'address1': address1,
    'address2': address2,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'country': country,
  };

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        fullName: json['fullName'],
        phone: json['phone'],
        address1: json['address1'],
        address2: json['address2'] ?? '',
        city: json['city'],
        state: json['state'],
        postalCode: json['postalCode'],
        country: json['country'],
      );

  String get fullAddress =>
      '$address1${address2.isNotEmpty ? ', $address2' : ''}, $city, $state $postalCode, $country';
}