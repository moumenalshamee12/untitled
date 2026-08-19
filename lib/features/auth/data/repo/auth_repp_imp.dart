import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:untitled/features/auth/domain/entites/user_entity.dart';
import 'package:untitled/features/auth/domain/repo/auth_repo.dart';

class AuthReppImp extends AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthReppImp({required this.authRemoteDataSource});
  @override
  Future<Either<Failure, UserEntity>> getprofile() async {
    try {
      var data = await authRemoteDataSource.getprofile();
      return right(data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String username,
    String password,
  ) async {
    try {
      var data = await authRemoteDataSource.login(username, password);

      return right(data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> signup(
    String username,
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      var data = await authRemoteDataSource.signup(
        username,
        name,
        email,
        phone,
        password,
      );
      return right(data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
