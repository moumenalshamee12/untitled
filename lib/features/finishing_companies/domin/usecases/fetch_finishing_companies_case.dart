import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';
import 'package:untitled/features/finishing_companies/domin/repo/finishing_company_repo.dart';

class FetchFinishingCompaniesCase {
  final FinishingCompanyRepo finishingCompanyRepo;

  FetchFinishingCompaniesCase({required this.finishingCompanyRepo});

  Future<Either<ServerFailure, List<FinishingCompanyEntity>>> call() async {
    return await finishingCompanyRepo.fetchFinishingCompanies();
  }
}

class FetchFinishingCompanyByIdCase {
  final FinishingCompanyRepo finishingCompanyRepo;

  FetchFinishingCompanyByIdCase({required this.finishingCompanyRepo});

  Future<Either<ServerFailure, FinishingCompanyEntity>> call(int id) async {
    return await finishingCompanyRepo.fetchFinishingCompanyById(id);
  }
}
