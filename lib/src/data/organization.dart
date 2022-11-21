class Organization {
  final int id;
  final String name;
  final String streetAddress;
  final String city;
  final int zip;

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
}
