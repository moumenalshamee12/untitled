import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/proreaty/data/data_source/proreaty_remote_data_source.dart';
import 'package:untitled/features/proreaty/domain/entities/prorety_entity.dart';
import 'package:untitled/features/proreaty/domain/repo/proreaty_repo.dart';

class PropertyRepoImp extends ProreatyRepo {
  final ProperatyRemoteDataSource ProperatyRemoteDataSourceImpl;

  PropertyRepoImp({required this.ProperatyRemoteDataSourceImpl});
  @override
  @override
  Future<Either<ServerFailure, List<PropertyEntity>>> fetchPropertiesById(
    int id,
  ) async {
    // TODO: implement fetchPropertiesById
    try {
      // Call the remote data source to fetch a real state by ID
      final properties = await ProperatyRemoteDataSourceImpl.getPropertyById(
        id,
      );
      return Right(properties);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
