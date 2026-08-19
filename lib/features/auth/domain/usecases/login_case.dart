import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/auth/domain/entites/user_entity.dart';
import 'package:untitled/features/auth/domain/repo/auth_repo.dart';

class LoginUseCase {
  final AuthRepo authRepo;

  LoginUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(
    String username,
    String password,
  ) async {
    return await authRepo.login(username, password);
  }
}
