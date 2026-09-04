import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/finishing_companies/data/data_source/finishing_company_remote_data_source.dart';
import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';
import 'package:untitled/features/finishing_companies/domin/repo/finishing_company_repo.dart';

class FinishingCompanyRepoImp extends FinishingCompanyRepo {
  final FinishingCompanyRemoteDataSource finishingCompanyRemoteDataSource;

  FinishingCompanyRepoImp({required this.finishingCompanyRemoteDataSource});

  @override
  Future<Either<ServerFailure, List<FinishingCompanyEntity>>>
  fetchFinishingCompanies() async {
    try {
      final companies = await finishingCompanyRemoteDataSource
          .getFinishingCompanies();
      return Right(companies);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, FinishingCompanyEntity>>
  fetchFinishingCompanyById(int id) async {
    try {
      final company = await finishingCompanyRemoteDataSource
          .getFinishingCompanyById(id);
      return Right(company);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
