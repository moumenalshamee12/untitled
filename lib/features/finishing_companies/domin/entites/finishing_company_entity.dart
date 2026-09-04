class FinishingCompanyEntity {
  final int id;
  final String commercialName;
  final String contactInfo;
  final String profileDescription;
  final bool isActive;
  final int userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<FinishingServiceEntity> services;
  final List<FinishingWorkAreaEntity> workAreas;
  final List<FinishingPortfolioItemEntity> portfolios;
  final List<dynamic> reviews;

  const FinishingCompanyEntity({
    required this.id,
    required this.commercialName,
    required this.contactInfo,
    required this.profileDescription,
    required this.isActive,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.services = const [],
    this.workAreas = const [],
    this.portfolios = const [],
    this.reviews = const [],
  });
}

class FinishingServiceEntity {
  final int id;
  final int finishingCompanyId;
  final String serviceType;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FinishingServiceEntity({
    required this.id,
    required this.finishingCompanyId,
    required this.serviceType,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });
}

class FinishingLocationEntity {
  final int id;
  final String city;
  final String neighborhood;
  final String region;
  final String addressDetails;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FinishingLocationEntity({
    required this.id,
    required this.city,
    required this.neighborhood,
    required this.region,
    required this.addressDetails,
    this.createdAt,
    this.updatedAt,
  });
}

class FinishingWorkAreaEntity {
  final int id;
  final int finishingCompanyId;
  final int locationId;
  final FinishingLocationEntity? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FinishingWorkAreaEntity({
    required this.id,
    required this.finishingCompanyId,
    required this.locationId,
    this.location,
    this.createdAt,
    this.updatedAt,
  });
}

class FinishingPortfolioItemEntity {
  final int id;
  final int finishingCompanyId;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FinishingPortfolioItemEntity({
    required this.id,
    required this.finishingCompanyId,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });
}
