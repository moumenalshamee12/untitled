import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';

abstract class FinishingCompaniesStates {}

class FinishingCompaniesInitialState extends FinishingCompaniesStates {}

class FinishingCompaniesLoadingState extends FinishingCompaniesStates {}

class FinishingCompaniesLoadedState extends FinishingCompaniesStates {
  final List<FinishingCompanyEntity> companies;

  FinishingCompaniesLoadedState(this.companies);
}

class FinishingCompaniesErrorState extends FinishingCompaniesStates {
  final String error;

  FinishingCompaniesErrorState(this.error);
}
