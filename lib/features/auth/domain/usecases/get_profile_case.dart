import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/auth/domain/entites/user_entity.dart';
import 'package:untitled/features/auth/domain/repo/auth_repo.dart';

class GetProfileUseCase {
  final AuthRepo authRepo;

  GetProfileUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call() async {
    return await authRepo.getprofile();
  }
}
