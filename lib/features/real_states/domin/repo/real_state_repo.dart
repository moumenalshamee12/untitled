import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';

abstract class RealStateRepo {
  Future<Either<ServerFailure, List<RealStateEntity>>> fetchrealstates();
  Future<Either<ServerFailure, RealStateEntity>> fetchrealstatebyid(int id);
}
