import 'package:untitled/features/proreaty/domain/entities/prorety_entity.dart';

class RealStateEntity {
  final int id;
  final String commercialName;
  final String address;
  final String licenseNumber;
  final String profileDescription;
  final String phoneNumber;
  final bool isActive;
  final List<PropertyEntity> properties;
  final int? userId;
  final String? userName;
  final String? userUsername;
  final String? userEmail;
  final String? userPhone;
  final String? userType;

  const RealStateEntity({
    required this.id,
    required this.commercialName,
    required this.address,
    required this.licenseNumber,
    required this.profileDescription,
    required this.phoneNumber,
    required this.isActive,
    required this.properties,
    this.userId,
    this.userName,
    this.userUsername,
    this.userEmail,
    this.userPhone,
    this.userType,
  });
}
