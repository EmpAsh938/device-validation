class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String deviceId;
  final String deviceInfo;
  final String status;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.deviceId,
    required this.deviceInfo,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      deviceId: json['device_id'],
      deviceInfo: json['device_info'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'device_id': deviceId,
      'device_info': deviceInfo,
      'status': status,
    };
  }
}
