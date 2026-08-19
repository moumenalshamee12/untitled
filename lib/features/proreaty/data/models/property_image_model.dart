import 'package:untitled/features/proreaty/domain/entities/prorety_image_entity.dart';



class PropertyImageModel extends PropertyImageEntity {
  const PropertyImageModel({
    required super.id,
    required super.imageUrl,
    required super.propertyId,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
      propertyId: json['property_id'] as int,
    );
  }
}