import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/requests/domain/entities/request_entity.dart';
import 'package:untitled/features/requests/domain/usecases/create_request_usecase.dart';

abstract class CreateRequestState {}

class CreateRequestInitial extends CreateRequestState {}

class CreateRequestLoading extends CreateRequestState {}

class CreateRequestSuccess extends CreateRequestState {
  final RequestEntity request;

  CreateRequestSuccess(this.request);
}

class CreateRequestFailure extends CreateRequestState {
  final String message;

  CreateRequestFailure(this.message);
}

class CreateRequestCubit extends Cubit<CreateRequestState> {
  final CreateRequestUseCase createRequestUseCase;

  CreateRequestCubit(this.createRequestUseCase) : super(CreateRequestInitial());

  Future<void> createRequest(Map<String, dynamic> data) async {
    emit(CreateRequestLoading());
    final result = await createRequestUseCase(data);
    result.fold(
      (failure) => emit(CreateRequestFailure(failure.message)),
      (request) => emit(CreateRequestSuccess(request)),
    );
  }
}
