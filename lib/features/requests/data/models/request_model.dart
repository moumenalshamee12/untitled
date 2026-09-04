import 'package:untitled/features/requests/domain/entities/request_entity.dart';

class RequestModel extends RequestEntity {
  const RequestModel({
    required super.id,
    required super.customerId,
    required super.companyId,
    required super.locationId,
    required super.statusId,
    required super.serviceType,
    required super.description,
    required super.area,
    required super.rooms,
    required super.floor,
    super.createdAt,
    super.updatedAt,
    super.company,
    super.status,
    super.location,
    super.images,
    super.response,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: _int(json['id']),
      customerId: _int(json['customer_id']),
      companyId: _int(json['company_id']),
      locationId: _int(json['location_id']),
      statusId: _int(json['status_id']),
      serviceType: json['service_type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      rooms: _int(json['rooms']),
      floor: _int(json['floor']),
      createdAt: _date(json['created_at']),
      updatedAt: _date(json['updated_at']),
      company: _company(json['company']),
      status: _status(json['status']),
      location: _location(json['location']),
      images: json['images'] as List<dynamic>? ?? const [],
      response: json['response'],
    );
  }

  static int _int(dynamic value) => int.tryParse(value.toString()) ?? 0;

  static DateTime? _date(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());

  static RequestCompanyEntity? _company(dynamic value) {
    if (value is! Map) return null;
    return RequestCompanyEntity(
      id: _int(value['id']),
      commercialName: value['commercial_name']?.toString() ?? '',
      contactInfo: value['contact_info']?.toString() ?? '',
      profileDescription: value['profile_description']?.toString() ?? '',
      isActive: value['is_active'] == 1 || value['is_active'] == true,
      userId: _int(value['user_id']),
    );
  }

  static RequestStatusEntity? _status(dynamic value) {
    if (value is! Map) return null;
    return RequestStatusEntity(
      id: _int(value['id']),
      statusName: value['status_name']?.toString() ?? '',
      entityType: value['entity_type']?.toString() ?? '',
      description: value['description']?.toString() ?? '',
    );
  }

  static RequestLocationEntity? _location(dynamic value) {
    if (value is! Map) return null;
    return RequestLocationEntity(
      id: _int(value['id']),
      city: value['city']?.toString() ?? '',
      neighborhood: value['neighborhood']?.toString() ?? '',
      region: value['region']?.toString() ?? '',
      addressDetails: value['address_details']?.toString() ?? '',
    );
  }
}
