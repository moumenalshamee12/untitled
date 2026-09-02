import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';

abstract class RealStateDetailsStates {}

class RealStateDetailsInitialState extends RealStateDetailsStates {}

class RealStateDetailsLoadingState extends RealStateDetailsStates {}

class RealStateDetailsLoadedState extends RealStateDetailsStates {
  final RealStateEntity realState;

  RealStateDetailsLoadedState(this.realState);
}

class RealStateDetailsErrorState extends RealStateDetailsStates {
  final String error;

  RealStateDetailsErrorState(this.error);
}
