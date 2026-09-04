import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';

class FinishingCompanyModel extends FinishingCompanyEntity {
  const FinishingCompanyModel({
    required super.id,
    required super.commercialName,
    required super.contactInfo,
    required super.profileDescription,
    required super.isActive,
    required super.userId,
    super.createdAt,
    super.updatedAt,
    super.services,
    super.workAreas,
    super.portfolios,
    super.reviews,
  });

  factory FinishingCompanyModel.fromJson(Map<String, dynamic> json) {
    final services = (json['services'] as List<dynamic>? ?? [])
        .map(
          (item) =>
              FinishingServiceModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    final workAreas = (json['workareas'] as List<dynamic>? ?? [])
        .map(
          (item) =>
              FinishingWorkAreaModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    final portfolios = (json['portfolios'] as List<dynamic>? ?? [])
        .map(
          (item) => FinishingPortfolioItemModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();

    return FinishingCompanyModel(
      id: json['id'] as int,
      commercialName:
          (json['commercial_name'] as String? ?? json['name'] as String? ?? ''),
      contactInfo: json['contact_info'] as String? ?? '',
      profileDescription: json['profile_description'] as String? ?? '',
      isActive: (json['is_active'] as num?) == 1 || json['is_active'] == true,
      userId: json['user_id'] as int? ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'] as String),
      services: services,
      workAreas: workAreas,
      portfolios: portfolios,
      reviews: (json['reviews'] as List<dynamic>? ?? const []),
    );
  }
}

class FinishingServiceModel extends FinishingServiceEntity {
  const FinishingServiceModel({
    required super.id,
    required super.finishingCompanyId,
    required super.serviceType,
    required super.description,
    super.createdAt,
    super.updatedAt,
  });

  factory FinishingServiceModel.fromJson(Map<String, dynamic> json) {
    return FinishingServiceModel(
      id: json['id'] as int,
      finishingCompanyId: json['finishing_company_id'] as int? ?? 0,
      serviceType: json['service_type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'] as String),
    );
  }
}

class FinishingLocationModel extends FinishingLocationEntity {
  const FinishingLocationModel({
    required super.id,
    required super.city,
    required super.neighborhood,
    required super.region,
    required super.addressDetails,
    super.createdAt,
    super.updatedAt,
  });

  factory FinishingLocationModel.fromJson(Map<String, dynamic> json) {
    return FinishingLocationModel(
      id: json['id'] as int,
      city: json['city'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      region: json['region'] as String? ?? '',
      addressDetails: json['address_details'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'] as String),
    );
  }
}

class FinishingWorkAreaModel extends FinishingWorkAreaEntity {
  const FinishingWorkAreaModel({
    required super.id,
    required super.finishingCompanyId,
    required super.locationId,
    super.location,
    super.createdAt,
    super.updatedAt,
  });

  factory FinishingWorkAreaModel.fromJson(Map<String, dynamic> json) {
    return FinishingWorkAreaModel(
      id: json['id'] as int,
      finishingCompanyId: json['finishing_company_id'] as int? ?? 0,
      locationId: json['location_id'] as int? ?? 0,
      location: json['location'] == null
          ? null
          : FinishingLocationModel.fromJson(
              json['location'] as Map<String, dynamic>,
            ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'] as String),
    );
  }
}

class FinishingPortfolioItemModel extends FinishingPortfolioItemEntity {
  const FinishingPortfolioItemModel({
    required super.id,
    required super.finishingCompanyId,
    required super.imageUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory FinishingPortfolioItemModel.fromJson(Map<String, dynamic> json) {
    return FinishingPortfolioItemModel(
      id: json['id'] as int,
      finishingCompanyId: json['finishing_company_id'] as int? ?? 0,
      imageUrl: json['image_url'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'] as String),
    );
  }
}
