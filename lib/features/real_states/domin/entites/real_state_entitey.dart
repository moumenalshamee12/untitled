import 'package:untitled/features/proreaty/domain/entities/prorety_entity.dart';

class RealStateEntitey {
  final int id;
  final String commercialName;
  final String address;
  final String licenseNumber;
  final String profileDescription;
  final String phoneNumber;
  final bool isActive;
  final List<PropertyEntity> properties;

  const RealStateEntitey({
    required this.id,
    required this.commercialName,
    required this.address,
    required this.licenseNumber,
    required this.profileDescription,
    required this.phoneNumber,
    required this.isActive,
    required this.properties,
  });
}
