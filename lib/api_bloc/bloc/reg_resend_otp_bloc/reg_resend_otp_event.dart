part of 'reg_resend_otp_bloc.dart';

sealed class RegResendOtpEvent extends Equatable {
  const RegResendOtpEvent();
  @override
  List<Object> get props => [];
}
class RegResendOtpData extends RegResendOtpEvent {
  final String Otpdata;
  RegResendOtpData(this.Otpdata);
}