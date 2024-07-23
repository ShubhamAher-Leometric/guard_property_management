import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/submitotpmodel.dart';
import '../../repository/SubmitForgotOtpRepository.dart';

part 'submit_forgot_otp_event.dart';
part 'submit_forgot_otp_state.dart';

class SubmitForgotOtpBloc extends Bloc<SubmitForgotOtpEvent, SubmitForgotOtpState> {
  SubmitForgotOtpBloc() : super(SubmitForgotOtpInitial()) {
    final SubmitForgetOtpApiRepository _apiRepository = SubmitForgetOtpApiRepository();
    on<SubmitForgetOtpData>((event, emit) async {
      try {
        emit(SubmitForgotOtpLoading());
        final userData = await _apiRepository.sendForgetOtp(event.Otpdata);
        emit(SubmitForgotOtpLoaded(userData));
        if (userData.error != null) {
          print(userData.error);
          emit(SubmitForgotOtpError(userData.error));
        }
      } on NetworkError {
        emit(SubmitForgotOtpError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
