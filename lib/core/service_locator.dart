import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:untitled/features/auth/data/repo/auth_repp_imp.dart';
import 'package:untitled/features/auth/domain/repo/auth_repo.dart';
import 'package:untitled/features/auth/domain/usecases/get_profile_case.dart';
import 'package:untitled/features/auth/domain/usecases/login_case.dart';
import 'package:untitled/features/auth/domain/usecases/signup_case.dart';
import 'package:untitled/features/finishing_companies/data/data_source/finishing_company_remote_data_source.dart';
import 'package:untitled/features/finishing_companies/data/repo/finishing_company_repo_imp.dart';
import 'package:untitled/features/finishing_companies/domin/repo/finishing_company_repo.dart';
import 'package:untitled/features/finishing_companies/domin/usecases/fetch_finishing_companies_case.dart';
import 'package:untitled/features/real_states/data/data_source/real_state_remote_data_source.dart';
import 'package:untitled/features/real_states/data/repo/real_state_repo_imp.dart';
import 'package:untitled/features/real_states/domin/repo/real_state_repo.dart';
import 'package:untitled/features/real_states/domin/usecases/fetch_real_state_case.dart';
import 'package:untitled/features/requests/data/data_source/request_remote_data_source.dart';
import 'package:untitled/features/requests/data/repositories/request_repository_impl.dart';
import 'package:untitled/features/requests/domain/repositories/request_repository.dart';
import 'package:untitled/features/requests/domain/usecases/create_request_usecase.dart';
import 'package:untitled/features/requests/domain/usecases/get_my_requests_usecase.dart';
import 'package:untitled/features/requests/domain/usecases/get_request_by_id_usecase.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  if (getIt.isRegistered<Dio>()) return;

  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio: getIt<Dio>()));

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceimp(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthReppImp(authRemoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  getIt.registerFactory<LoginUseCase>(
    () => LoginUseCase(authRepo: getIt<AuthRepo>()),
  );
  getIt.registerFactory<SignupUseCase>(
    () => SignupUseCase(authRepo: getIt<AuthRepo>()),
  );
  getIt.registerFactory<GetProfileUseCase>(
    () => GetProfileUseCase(authRepo: getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<RealStateRemoteDatasource>(
    () => RealStateRemoteDatasourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RealStateRepo>(
    () => RealStateRepoImp(
      realStateRemoteDatasource: getIt<RealStateRemoteDatasource>(),
    ),
  );
  getIt.registerFactory<FetchRealStateCase>(
    () => FetchRealStateCase(realStateRepo: getIt<RealStateRepo>()),
  );

  getIt.registerLazySingleton<FinishingCompanyRemoteDataSource>(
    () => FinishingCompanyRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<FinishingCompanyRepo>(
    () => FinishingCompanyRepoImp(
      finishingCompanyRemoteDataSource:
          getIt<FinishingCompanyRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<FetchFinishingCompaniesCase>(
    () => FetchFinishingCompaniesCase(
      finishingCompanyRepo: getIt<FinishingCompanyRepo>(),
    ),
  );
  getIt.registerFactory<FetchFinishingCompanyByIdCase>(
    () => FetchFinishingCompanyByIdCase(
      finishingCompanyRepo: getIt<FinishingCompanyRepo>(),
    ),
  );

  getIt.registerLazySingleton<RequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(
      remoteDataSource: getIt<RequestRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<CreateRequestUseCase>(
    () => CreateRequestUseCase(repository: getIt<RequestRepository>()),
  );
  getIt.registerFactory<GetMyRequestsUseCase>(
    () => GetMyRequestsUseCase(repository: getIt<RequestRepository>()),
  );
  getIt.registerFactory<GetRequestByIdUseCase>(
    () => GetRequestByIdUseCase(repository: getIt<RequestRepository>()),
  );
}
