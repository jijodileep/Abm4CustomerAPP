import 'package:equatable/equatable.dart';

enum UserType { dealer, transporter }

class User extends Equatable {
  final String id;
  final String mobileNumber;
  final String? dealerId;
  final String? transporterId;
  final String name;
  final String email;
  final UserType userType;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.mobileNumber,
    this.dealerId,
    this.transporterId,
    required this.name,
    required this.email,
    required this.userType,
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      mobileNumber: json['mobile_number'] as String,
      dealerId: json['dealer_id'] as String?,
      transporterId: json['transporter_id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: UserType.values.firstWhere(
        (type) => type.name == json['user_type'],
        orElse: () => UserType.dealer,
      ),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile_number': mobileNumber,
      'dealer_id': dealerId,
      'transporter_id': transporterId,
      'name': name,
      'email': email,
      'user_type': userType.name,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? mobileNumber,
    String? dealerId,
    String? transporterId,
    String? name,
    String? email,
    UserType? userType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      dealerId: dealerId ?? this.dealerId,
      transporterId: transporterId ?? this.transporterId,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    mobileNumber,
    dealerId,
    transporterId,
    name,
    email,
    userType,
    isActive,
    createdAt,
    lastLoginAt,
  ];
}
