import 'package:bloc/bloc.dart';
import 'package:untitled/features/real_states/domin/usecases/fetch_real_state_case.dart';
import 'package:untitled/features/real_states/presentoin/manger/real_states_cubit/real_states_states.dart';

class RealStatesCubit extends Cubit<RealStatesStates> {
  final FetchRealStateCase fetchRealStateCase;

  RealStatesCubit(this.fetchRealStateCase) : super(RealStatesInitialState());

  Future<void> fetchRealStates() async {
    emit(RealStatesLoadingState());
    final result = await fetchRealStateCase.call();
    result.fold(
      (failure) => emit(RealStatesErrorState(failure.message)),
      (realStates) => emit(RealStatesLoadedState(realStates)),
    );
  }
}
