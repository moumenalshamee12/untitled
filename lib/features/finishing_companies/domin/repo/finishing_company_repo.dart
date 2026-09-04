import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';

abstract class FinishingCompanyRepo {
  Future<Either<ServerFailure, List<FinishingCompanyEntity>>>
  fetchFinishingCompanies();

  Future<Either<ServerFailure, FinishingCompanyEntity>>
  fetchFinishingCompanyById(int id);
}
