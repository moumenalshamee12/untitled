import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/requests/domain/entities/request_entity.dart';
import 'package:untitled/features/requests/domain/repositories/request_repository.dart';

class GetMyRequestsUseCase {
  final RequestRepository repository;

  GetMyRequestsUseCase({required this.repository});

  Future<Either<ServerFailure, List<RequestEntity>>> call() =>
      repository.getMyRequests();
}
