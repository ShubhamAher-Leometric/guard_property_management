import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/resendotpmodel.dart';
import '../../repository/RegResendOtpRepository.dart';
part 'reg_resend_otp_event.dart';
part 'reg_resend_otp_state.dart';

class RegResendOtpBloc extends Bloc<RegResendOtpEvent, RegResendOtpState> {
  RegResendOtpBloc() : super(RegResendOtpInitial()) {
    final RegResendOtpApiRepository _apiRepository = RegResendOtpApiRepository();

    on<RegResendOtpData>((event, emit) async {
      try {
        emit(RegResendOtpLoading());
        final userData = await _apiRepository.sendRegOtp(event.Otpdata);
        emit(RegResendOtpLoaded(userData));
        if (userData.error != null) {
          print(userData.error);
          emit(RegResendOtpError(userData.error));
        }
      } on NetworkError {
        emit(RegResendOtpError("Failed to fetch data. is your device online?"));
      }     });
  }
}
