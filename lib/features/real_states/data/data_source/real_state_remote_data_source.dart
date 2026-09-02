import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/features/real_states/data/models/real_state_model.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';

abstract class RealStateRemoteDatasource {
  Future<List<RealStateEntity>> getRealStates();
  Future<RealStateEntity> getRealStateById(int id);
}

class RealStateRemoteDatasourceImpl extends RealStateRemoteDatasource {
  final ApiService apiService;
  RealStateRemoteDatasourceImpl({required this.apiService});

  @override
  Future<List<RealStateEntity>> getRealStates() async {
    var data = await apiService.get('real-estate-offices');

    List<RealEstateModel> realstates = [];
    for (var realstate in data['data']) {
      realstates.add(RealEstateModel.fromJson(realstate));
    }

    return realstates;
  }

  @override
  Future<RealStateEntity> getRealStateById(int id) async {
    var data = await apiService.get('real-estate-offices/$id');
    final office = data['office'] ?? data['data'] ?? data;

    return RealEstateModel.fromJson(Map<String, dynamic>.from(office as Map));
  }
}
