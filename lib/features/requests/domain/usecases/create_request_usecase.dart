import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/requests/domain/entities/request_entity.dart';
import 'package:untitled/features/requests/domain/repositories/request_repository.dart';

class CreateRequestUseCase {
  final RequestRepository repository;

  CreateRequestUseCase({required this.repository});

  Future<Either<ServerFailure, RequestEntity>> call(
    Map<String, dynamic> data,
  ) => repository.createRequest(data);
}
