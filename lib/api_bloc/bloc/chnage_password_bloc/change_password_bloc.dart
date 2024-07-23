import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/changepassword_model.dart';
import '../../repository/ChangePasswordRepository.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePassWordApiRepository _apiRepository = ChangePassWordApiRepository();

  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordData>((event, emit) async {
      try {
        emit(ChangePasswordLoading());
        final userData = await _apiRepository.sendNewPassword(event.newPasswordData);
        emit(ChangePasswordLoaded(userData));
        if (userData.error != null) {
          print(userData.error);
          emit(ChangePasswordError(userData.error));
        }
      } on NetworkError {
        emit(ChangePasswordError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
