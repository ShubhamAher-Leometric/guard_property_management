part of 'forget_otp_bloc.dart';

abstract class ForgetOtpEvent extends Equatable {
  const ForgetOtpEvent();
  @override
  List<Object> get props => [];
}
class ForgetOtpData extends ForgetOtpEvent {
  final String Otpdata;
  ForgetOtpData(this.Otpdata);
}