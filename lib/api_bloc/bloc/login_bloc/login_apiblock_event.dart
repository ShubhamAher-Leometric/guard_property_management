part of 'login_apiblock_bloc.dart';

abstract class LoginApiblockEvent extends Equatable {
  const LoginApiblockEvent();
  @override
  List<Object> get props => [];
}

class LoginApiData extends LoginApiblockEvent {
  final String LoginData;
  LoginApiData(this.LoginData);
}
