import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/features/finishing_companies/data/models/finishing_company_model.dart';
import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';

abstract class FinishingCompanyRemoteDataSource {
  Future<List<FinishingCompanyEntity>> getFinishingCompanies();
  Future<FinishingCompanyEntity> getFinishingCompanyById(int id);
}

class FinishingCompanyRemoteDataSourceImpl
    extends FinishingCompanyRemoteDataSource {
  final ApiService apiService;

  FinishingCompanyRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<FinishingCompanyEntity>> getFinishingCompanies() async {
    final data = await apiService.get('finishing-companies');
    final items = data['data'] as List<dynamic>? ?? const [];

    return items
        .map(
          (item) =>
              FinishingCompanyModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<FinishingCompanyEntity> getFinishingCompanyById(int id) async {
    final data = await apiService.get('finishing-companies/$id');
    final item = data['data'] ?? data['company'] ?? data;

    return FinishingCompanyModel.fromJson(
      Map<String, dynamic>.from(item as Map),
    );
  }
}
