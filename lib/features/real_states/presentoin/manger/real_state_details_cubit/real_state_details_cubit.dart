import 'package:bloc/bloc.dart';
import 'package:untitled/features/real_states/domin/usecases/fetch_real_state-by_id_case.dart';
import 'package:untitled/features/real_states/presentoin/manger/real_state_details_cubit/real_state_details_states.dart';

class RealStateDetailsCubit extends Cubit<RealStateDetailsStates> {
  final FetchRealStateByIdCase fetchRealStateByIdCase;

  RealStateDetailsCubit(this.fetchRealStateByIdCase)
    : super(RealStateDetailsInitialState());

  Future<void> fetchRealStateById(int id) async {
    emit(RealStateDetailsLoadingState());
    final result = await fetchRealStateByIdCase.call(id);
    result.fold(
      (failure) => emit(RealStateDetailsErrorState(failure.message)),
      (realState) => emit(RealStateDetailsLoadedState(realState)),
    );
  }
}
