import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/core/utils/token.dart';
import 'package:untitled/features/auth/data/models/user_model.dart';
import 'package:untitled/features/auth/domain/entites/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> login(String username, String password);
  Future<UserEntity> signup(
    String username,
    String name,
    String email,
    String phone,
    String password,
  );
  Future<UserEntity> getprofile();
}

class AuthRemoteDataSourceimp extends AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceimp({required ApiService apiService})
    : _apiService = apiService;
  @override
  Future<UserEntity> getprofile() async {
    var data = await _apiService.get('me');

    var user = data["user"];
    return UserModel.fromJson(user);
  }

  @override
  Future<UserEntity> login(String username, String password) async {
    final response = await _apiService.post(
      'login',
      data: {"email": username, "password": password},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid login response format');
    }

    final result = data['user'];
    final token = data['token']?.toString();

    if (token == null || token.isEmpty) {
      throw Exception('Login response missing token');
    }

    await Token().savetoken(token);
    return UserModel.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<UserEntity> signup(
    String username,
    String name,
    String email,
    String phone,
    String password,
  ) async {
    final response = await _apiService.post(
      'register',
      data: {
        "username": username,
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      },
    );
    final result = response.data['user'];

    return UserModel.fromJson(result);
  }
}
