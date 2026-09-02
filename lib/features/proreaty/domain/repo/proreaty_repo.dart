import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/proreaty/domain/entities/prorety_entity.dart';

abstract class ProreatyRepo {
  Future<Either<ServerFailure, List<PropertyEntity>>> fetchPropertiesById(
    int id,
  );
}
