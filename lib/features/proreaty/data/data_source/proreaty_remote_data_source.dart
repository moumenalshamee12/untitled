import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/features/proreaty/data/models/property_model.dart';
import 'package:untitled/features/proreaty/domain/entities/prorety_entity.dart';

abstract class ProperatyRemoteDataSource {
  Future<List<PropertyEntity>> getPropertyById(int id);
}

class ProperatyRemoteDataSourceImpl extends ProperatyRemoteDataSource {
  final ApiService apiService;
  ProperatyRemoteDataSourceImpl({required this.apiService});
  Future<List<PropertyEntity>> getPropertyById(int id) async {
    var data = await apiService.get('real-estate-offices/$id');

    List<PropertyModel> properties = [];
    for (var property in data['office']['properties']) {
      properties.add(PropertyModel.fromJson(property));
    }

    return properties;
  }
}
