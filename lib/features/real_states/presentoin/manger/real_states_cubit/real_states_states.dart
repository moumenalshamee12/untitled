import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';

abstract class RealStatesStates {}

class RealStatesInitialState extends RealStatesStates {}

class RealStatesLoadingState extends RealStatesStates {}

class RealStatesLoadedState extends RealStatesStates {
  final List<RealStateEntity> realStates;

  RealStatesLoadedState(this.realStates);
}

class RealStatesErrorState extends RealStatesStates {
  final String error;

  RealStatesErrorState(this.error);
}
