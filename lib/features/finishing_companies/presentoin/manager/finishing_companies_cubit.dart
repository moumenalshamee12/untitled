import 'package:bloc/bloc.dart';
import 'package:untitled/features/finishing_companies/domin/usecases/fetch_finishing_companies_case.dart';
import 'package:untitled/features/finishing_companies/presentoin/manager/finishing_companies_states.dart';

class FinishingCompaniesCubit extends Cubit<FinishingCompaniesStates> {
  final FetchFinishingCompaniesCase fetchFinishingCompaniesCase;

  FinishingCompaniesCubit(this.fetchFinishingCompaniesCase)
    : super(FinishingCompaniesInitialState());

  Future<void> fetchFinishingCompanies() async {
    emit(FinishingCompaniesLoadingState());
    final result = await fetchFinishingCompaniesCase.call();
    result.fold(
      (failure) => emit(FinishingCompaniesErrorState(failure.message)),
      (companies) => emit(FinishingCompaniesLoadedState(companies)),
    );
  }
}
