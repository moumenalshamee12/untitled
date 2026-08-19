import 'package:untitled/features/proreaty/domain/entities/prorety_entity.dart';


import 'property_image_model.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.price,
    required super.area,
    required super.rooms,
    required super.legalStatus,
    required super.offerType,
    required super.statusId,
    required super.contactVisible,
    required super.realEstateOfficeId,
    required super.locationId,
    required super.images,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      price: double.parse(json['price'].toString()),
      area: double.parse(json['area'].toString()),
      rooms: json['rooms'] as int,
      legalStatus: json['legal_status'] as String,
      offerType: json['offer_type'] as String,
      statusId: json['status_id'] as int,
      contactVisible: json['contact_visible'] as bool,
      realEstateOfficeId: json['real_estate_office_id'] as int,
      locationId: json['location_id'] as int,
      images: (json['images'] as List<dynamic>? ?? [])
          .map(
            (image) => PropertyImageModel.fromJson(
              image as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}