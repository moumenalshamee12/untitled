import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/real_states/data/data_source/real_state_remote_data_source.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';
import 'package:untitled/features/real_states/domin/repo/real_state_repo.dart';

class RealStateRepoImp extends RealStateRepo {
  final RealStateRemoteDatasource realStateRemoteDatasource;
  RealStateRepoImp({required this.realStateRemoteDatasource});
  @override
  Future<Either<ServerFailure, List<RealStateEntity>>> fetchrealstates() async {
    try {
      // Call the remote data source to fetch real states
      final realStates = await realStateRemoteDatasource.getRealStates();
      return Right(realStates);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, RealStateEntity>> fetchrealstatebyid(
    int id,
  ) async {
    try {
      // Call the remote data source to fetch a real state by ID
      final realState = await realStateRemoteDatasource.getRealStateById(id);
      return Right(realState);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
