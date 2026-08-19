import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';

abstract class RealStateRepo {
  Future<Either<ServerFailure, List<RealStateEntitey>>> fetchrealstate();
  Future<Either<ServerFailure, RealStateEntitey>> fetchrealstatebyid(int id);
}
