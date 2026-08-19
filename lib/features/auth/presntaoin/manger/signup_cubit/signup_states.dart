abstract class SignupStates {}

class SignupInitialState extends SignupStates {}

class SignupLoadingState extends SignupStates {}

class SignupSuccessState extends SignupStates {
  final String message;

  SignupSuccessState(this.message);
}

class SignupErrorState extends SignupStates {
  final String error;

  SignupErrorState(this.error);
}
