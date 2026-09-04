import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/requests/domain/entities/request_entity.dart';

abstract class RequestRepository {
  Future<Either<ServerFailure, RequestEntity>> createRequest(
    Map<String, dynamic> data,
  );
  Future<Either<ServerFailure, List<RequestEntity>>> getMyRequests();
  Future<Either<ServerFailure, RequestEntity>> getRequestById(int id);
}
