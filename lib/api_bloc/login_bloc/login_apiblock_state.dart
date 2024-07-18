part of 'login_apiblock_bloc.dart';

abstract class LoginApiblockState extends Equatable {
  const LoginApiblockState();
}

class LoginApiblockInitial extends LoginApiblockState {
  @override
  List<Object> get props => [];
}

class LoginApiblockLoading extends LoginApiblockState {
  @override
  List<Object> get props => [];
}

class LoginApiblockError extends LoginApiblockState {
  late final String? message;
  LoginApiblockError(this.message);

  @override
  List<Object> get props => [];
}

class LoginApiblockLoaded extends LoginApiblockState {
  @override
  List<Object> get props => [];

  final LoginModel loginModel;
  const LoginApiblockLoaded(this.loginModel);
}
