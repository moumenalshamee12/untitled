import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/auth/domain/entites/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> login(String username, String password);
  Future<Either<Failure, UserEntity>> signup(
    String username,
    String name,
    String email,
    String phone,
    String password,
  );
  Future<Either<Failure, UserEntity>> logout();
  Future<Either<Failure, UserEntity>> getprofile();
}
