import 'package:untitled/features/auth/domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  final int? id;
  final String? userType;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    String? username,
    String? name,
    String? email,
    String? phone,
    int? isActive,
    this.userType,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  }) : super(
         name: name,
         username: username,
         email: email,
         phone: phone,
         isActive: isActive,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int?,
    username: json['username'] as String?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    isActive: json['is_active'] as int?,
    userType: json['user_type'] as String?,
    emailVerifiedAt: json['email_verified_at'],
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'name': name,
    'email': email,
    'phone': phone,
    'is_active': isActive,
    'user_type': userType,
    'email_verified_at': emailVerifiedAt,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
