part of 'submit_forgot_otp_bloc.dart';

abstract class SubmitForgotOtpEvent extends Equatable {
  SubmitForgotOtpEvent();
   @override
   List<Object> get props => [];
}
class SubmitForgetOtpData extends SubmitForgotOtpEvent {
  final String Otpdata;
  SubmitForgetOtpData(this.Otpdata);
}