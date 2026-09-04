import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/requests/domain/entities/request_entity.dart';
import 'package:untitled/features/requests/domain/usecases/get_my_requests_usecase.dart';

abstract class MyRequestsState {}

class MyRequestsInitial extends MyRequestsState {}

class MyRequestsLoading extends MyRequestsState {}

class MyRequestsLoaded extends MyRequestsState {
  final List<RequestEntity> requests;
  MyRequestsLoaded(this.requests);
}

class MyRequestsFailure extends MyRequestsState {
  final String message;
  MyRequestsFailure(this.message);
}

class MyRequestsCubit extends Cubit<MyRequestsState> {
  final GetMyRequestsUseCase getMyRequestsUseCase;
  MyRequestsCubit(this.getMyRequestsUseCase) : super(MyRequestsInitial());

  Future<void> load() async {
    emit(MyRequestsLoading());
    final result = await getMyRequestsUseCase();
    result.fold(
      (failure) => emit(MyRequestsFailure(failure.message)),
      (requests) => emit(MyRequestsLoaded(requests)),
    );
  }
}
