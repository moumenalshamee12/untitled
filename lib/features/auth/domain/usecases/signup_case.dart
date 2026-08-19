import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/auth/domain/entites/user_entity.dart';
import 'package:untitled/features/auth/domain/repo/auth_repo.dart';

class SignupUseCase {
  final AuthRepo authRepo;

  SignupUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(
    String username,
    String password,
    String name,
    String email,
    String phone,
  ) async {
    return await authRepo.signup(username, name, email, phone, password);
  }
}
