part of 'submit_forgot_otp_bloc.dart';

abstract class SubmitForgotOtpState extends Equatable {
  const SubmitForgotOtpState();
}

final class SubmitForgotOtpInitial extends SubmitForgotOtpState {
  @override
  List<Object> get props => [];
}

class SubmitForgotOtpLoading extends SubmitForgotOtpState {
  @override
  List<Object> get props => [];
}

class SubmitForgotOtpError extends SubmitForgotOtpState {
  late final String? message;
  SubmitForgotOtpError(this.message);

  @override
  List<Object> get props => [];
}

class SubmitForgotOtpLoaded extends SubmitForgotOtpState {
  @override
  List<Object> get props => [];

  final SubmitOtpModel submitforgotOtpModel;
  const SubmitForgotOtpLoaded(this.submitforgotOtpModel);
}
