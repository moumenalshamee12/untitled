import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/proreaty/domain/entities/prorety_entity.dart';
import 'package:untitled/features/proreaty/domain/repo/proreaty_repo.dart';

class FetchPropertyByIdCase {
  final ProreatyRepo proreatyRepo;

  FetchPropertyByIdCase({required this.proreatyRepo});

  Future<Either<ServerFailure, List<PropertyEntity>>> call(int id) async {
    return await proreatyRepo.fetchPropertiesById(id);
  }
}
