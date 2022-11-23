// Sample response:
// "id": 3,
// "first_name": "Miika",
// "last_name": "Sikala",
// "email": "miika@example.com",
// "email_verified_at": null,
// "organization_id": null,
// "role": "student",
// "phone": null,
// "created_at": "2022-11-21T20:34:49.000000Z",
// "updated_at": "2022-11-21T20:34:49.000000Z"

enum UserRole {
  teacher('teacher'),
  student('student');

  const UserRole(this.str);

  /// create a role based on strings like 'TEACHER' and 'STUDENT'
  factory UserRole.fromString(String str) =>
      (str.toLowerCase() == teacher.str) ? UserRole.teacher : UserRole.student;
  final String str;
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final bool emailVerified;
  final UserRole role;
  final String? phone;
  final int? organizationId;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerified,
    required this.role,
    this.phone,
    this.organizationId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      emailVerified: json['email_verified_at'] != null,
      role: UserRole.fromString(json['role']),
      phone: json['phone'],
      organizationId: json['organization_id'],
    );
  }

  String get name => '$firstName $lastName';
}
