class RequestEntity {
  final int id;
  final int customerId;
  final int companyId;
  final int locationId;
  final int statusId;
  final String serviceType;
  final String description;
  final String area;
  final int rooms;
  final int floor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final RequestCompanyEntity? company;
  final RequestStatusEntity? status;
  final RequestLocationEntity? location;
  final List<dynamic> images;
  final dynamic response;

  const RequestEntity({
    required this.id,
    required this.customerId,
    required this.companyId,
    required this.locationId,
    required this.statusId,
    required this.serviceType,
    required this.description,
    required this.area,
    required this.rooms,
    required this.floor,
    this.createdAt,
    this.updatedAt,
    this.company,
    this.status,
    this.location,
    this.images = const [],
    this.response,
  });
}

class RequestCompanyEntity {
  final int id;
  final String commercialName;
  final String contactInfo;
  final String profileDescription;
  final bool isActive;
  final int userId;

  const RequestCompanyEntity({
    required this.id,
    required this.commercialName,
    required this.contactInfo,
    required this.profileDescription,
    required this.isActive,
    required this.userId,
  });
}

class RequestStatusEntity {
  final int id;
  final String statusName;
  final String entityType;
  final String description;

  const RequestStatusEntity({
    required this.id,
    required this.statusName,
    required this.entityType,
    required this.description,
  });
}

class RequestLocationEntity {
  final int id;
  final String city;
  final String neighborhood;
  final String region;
  final String addressDetails;

  const RequestLocationEntity({
    required this.id,
    required this.city,
    required this.neighborhood,
    required this.region,
    required this.addressDetails,
  });
}
