import 'package:untitled/features/proreaty/data/models/property_model.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';

class RealEstateModel extends RealStateEntitey {
  const RealEstateModel({
    required super.id,
    required super.commercialName,
    required super.address,
    required super.licenseNumber,
    required super.profileDescription,
    required super.phoneNumber,
    required super.isActive,
    required super.properties,
  });

  factory RealEstateModel.fromJson(Map<String, dynamic> json) {
    return RealEstateModel(
      id: json['id'] as int,
      commercialName: json['commercial_name'] as String,
      address: json['address'] as String,
      licenseNumber: json['license_number'] as String,
      profileDescription: json['profile_description'] as String,
      phoneNumber: json['phone_number'] as String,
      isActive: json['is_active'] as bool,
      properties: (json['properties'] as List<dynamic>? ?? [])
          .map(
            (property) =>
                PropertyModel.fromJson(property as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
