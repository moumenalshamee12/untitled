import 'package:untitled/features/proreaty/data/models/property_model.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';

class RealEstateModel extends RealStateEntity {
  const RealEstateModel({
    required super.id,
    required super.commercialName,
    required super.address,
    required super.licenseNumber,
    required super.profileDescription,
    required super.phoneNumber,
    required super.isActive,
    required super.properties,
    super.userId,
    super.userName,
    super.userUsername,
    super.userEmail,
    super.userPhone,
    super.userType,
  });

  factory RealEstateModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};

    return RealEstateModel(
      id: json['id'] as int,
      commercialName: json['commercial_name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      licenseNumber: json['license_number'] as String? ?? '',
      profileDescription: json['profile_description'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      properties: (json['properties'] as List<dynamic>? ?? [])
          .map(
            (property) =>
                PropertyModel.fromJson(property as Map<String, dynamic>),
          )
          .toList(),
      userId: user['id'] as int?,
      userName: user['name'] as String?,
      userUsername: user['username'] as String?,
      userEmail: user['email'] as String?,
      userPhone: user['phone'] as String?,
      userType: user['user_type'] as String?,
    );
  }
}
