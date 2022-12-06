// Sample response:
// "id": 1,
// "name": "Vihannin Koulu",
// "street_address": "Yläkouluntie 9",
// "city": "Raahe",
// "zip": 86400,
// "created_at": "2022-10-09T12:11:51.000000Z",
// "updated_at": "2022-10-09T12:11:51.000000Z"

class Organization {
  final int id;
  final String name;
  final String streetAddress;
  final String city;
  final String zip;

  const Organization({
    required this.id,
    required this.name,
    required this.streetAddress,
    required this.city,
    required this.zip,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
      streetAddress: json['street_address'],
      city: json['city'],
      zip: json['zip'],
    );
  }

  String get completeAddress => '$streetAddress, $zip $city';
}
