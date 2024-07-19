import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/LoginModel.dart';
import '../../repository/LoginRepository.dart';



part 'login_apiblock_event.dart';
part 'login_apiblock_state.dart';

class LoginApiblockBloc extends Bloc<LoginApiblockEvent, LoginApiblockState> {
  LoginApiblockBloc() : super(LoginApiblockInitial()) {
    final LoginApiRepository _apiRepository = LoginApiRepository();
    on<LoginApiData>((event, emit) async {
      try {
        emit(LoginApiblockLoading());
        final userData = await _apiRepository.sendLoginOtp(event.LoginData);
        emit(LoginApiblockLoaded(userData));
        if (userData.error != null) {
          print(userData.error);
          emit(LoginApiblockError(userData.error));
        }
      } on NetworkError {
        emit(LoginApiblockError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
