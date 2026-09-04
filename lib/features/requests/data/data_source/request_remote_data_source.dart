import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/features/requests/data/models/request_model.dart';

abstract class RequestRemoteDataSource {
  Future<RequestModel> createRequest(Map<String, dynamic> data);
  Future<List<RequestModel>> getMyRequests();
  Future<RequestModel> getRequestById(int id);
}

class RequestRemoteDataSourceImpl extends RequestRemoteDataSource {
  final ApiService apiService;
  static const String createRequestEndpoint = 'customer/finishing-requests';

  RequestRemoteDataSourceImpl({required this.apiService});

  @override
  Future<RequestModel> createRequest(Map<String, dynamic> data) async {
    final response = await apiService.post(createRequestEndpoint, data: data);
    final body = response.data;
    final result = body is Map
        ? (body['data'] ?? body['request'] ?? body)
        : body;
    return RequestModel.fromJson(Map<String, dynamic>.from(result as Map));
  }

  @override
  Future<List<RequestModel>> getMyRequests() async {
    final data = await apiService.get('customer/finishing-requests');
    final items = data['data'] is List ? data['data'] as List : const [];
    return items
        .map(
          (item) =>
              RequestModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  @override
  Future<RequestModel> getRequestById(int id) async {
    final data = await apiService.get('customer/finishing-requests/$id');
    final result = data['data'] ?? data['request'] ?? data;
    return RequestModel.fromJson(Map<String, dynamic>.from(result as Map));
  }
}
