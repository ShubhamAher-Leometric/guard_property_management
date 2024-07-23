import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/forgetotpmodel.dart';
import '../../repository/ForgetOtpRepository.dart';

part 'forget_otp_event.dart';
part 'forget_otp_state.dart';

class ForgetOtpBloc extends Bloc<ForgetOtpEvent, ForgetOtpState> {
  ForgetOtpBloc() : super(ForgetOtpInitial()) {
    final ForgetOtpApiRepository _apiRepository = ForgetOtpApiRepository();
    on<ForgetOtpData>((event, emit) async {
      try {
        emit(ForgetOtpLoading());
        final userData = await _apiRepository.sendForgetOtp(event.Otpdata);
        emit(ForgetOtpLoaded(userData));
        if (userData.error != null) {
          print(userData.error);
          emit(ForgetOtpError(userData.error));
        }
      } on NetworkError {
        emit(ForgetOtpError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
