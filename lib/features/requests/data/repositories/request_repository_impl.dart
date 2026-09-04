import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/requests/data/data_source/request_remote_data_source.dart';
import 'package:untitled/features/requests/domain/entities/request_entity.dart';
import 'package:untitled/features/requests/domain/repositories/request_repository.dart';

class RequestRepositoryImpl extends RequestRepository {
  final RequestRemoteDataSource remoteDataSource;

  RequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ServerFailure, RequestEntity>> createRequest(
    Map<String, dynamic> data,
  ) async {
    try {
      return Right(await remoteDataSource.createRequest(data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, List<RequestEntity>>> getMyRequests() async {
    try {
      return Right(await remoteDataSource.getMyRequests());
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, RequestEntity>> getRequestById(int id) async {
    try {
      return Right(await remoteDataSource.getRequestById(id));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
