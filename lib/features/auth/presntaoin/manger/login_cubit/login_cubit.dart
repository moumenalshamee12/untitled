import 'package:bloc/bloc.dart';
import 'package:untitled/features/auth/domain/usecases/login_case.dart';
import 'package:untitled/features/auth/presntaoin/manger/login_cubit/login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitialState());

  Future<void> login(String username, String password) async {
    emit(LoginLoadingState());
    final result = await loginUseCase.call(username, password);
    result.fold(
      (failure) => emit(LoginErrorState(failure.message)),
      (user) => emit(
        LoginSuccessState('Login successful! Welcome ${user.name ?? 'user'}'),
      ),
    );
  }
}
