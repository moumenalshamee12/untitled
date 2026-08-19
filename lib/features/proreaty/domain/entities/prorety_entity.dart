import 'package:untitled/features/proreaty/domain/entities/prorety_image_entity.dart';

class PropertyEntity {
  final int id;
  final String title;
  final String description;
  final String type;
  final double price;
  final double area;
  final int rooms;
  final String legalStatus;
  final String offerType;
  final int statusId;
  final bool contactVisible;
  final int realEstateOfficeId;
  final int locationId;
  final List<PropertyImageEntity> images;

  const PropertyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.price,
    required this.area,
    required this.rooms,
    required this.legalStatus,
    required this.offerType,
    required this.statusId,
    required this.contactVisible,
    required this.realEstateOfficeId,
    required this.locationId,
    required this.images,
  });
}
