import 'package:bloc/bloc.dart';
import 'package:untitled/features/auth/domain/usecases/signup_case.dart';
import 'package:untitled/features/auth/presntaoin/manger/signup_cubit/signup_states.dart';

class SignupCubit extends Cubit<SignupStates> {
  final SignupUseCase signupUseCase;

  SignupCubit(this.signupUseCase) : super(SignupInitialState());

  Future<void> signup(
    String username,
    String password,
    String name,
    String email,
    String phone,
  ) async {
    emit(SignupLoadingState());
    final result = await signupUseCase.call(
      username,
      password,
      name,
      email,
      phone,
    );
    result.fold(
      (failure) => emit(SignupErrorState(failure.message)),
      (user) => emit(
        SignupSuccessState('Signup successful! Welcome ${user.name ?? 'user'}'),
      ),
    );
  }
}
