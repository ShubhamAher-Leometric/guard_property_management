part of 'forget_otp_bloc.dart';

abstract class ForgetOtpState extends Equatable {
  const ForgetOtpState();
}

final class ForgetOtpInitial extends ForgetOtpState {
  @override
  List<Object> get props => [];
}

class ForgetOtpLoading extends ForgetOtpState {
  @override
  List<Object> get props => [];
}

class ForgetOtpError extends ForgetOtpState {
  late final String? message;
  ForgetOtpError(this.message);

  @override
  List<Object> get props => [];
}

class ForgetOtpLoaded extends ForgetOtpState {
  @override
  List<Object> get props => [];

  final ForgotOtpModel forgotOtpModel;
  const ForgetOtpLoaded(this.forgotOtpModel);
}
