part of 'reg_resend_otp_bloc.dart';

sealed class RegResendOtpState extends Equatable {
  const RegResendOtpState();
}

final class RegResendOtpInitial extends RegResendOtpState {
  @override
  List<Object> get props => [];
}

class RegResendOtpLoading extends RegResendOtpState {
  @override
  List<Object> get props => [];
}

class RegResendOtpError extends RegResendOtpState {
  late final String? message;
  RegResendOtpError(this.message);

  @override
  List<Object> get props => [];
}

class RegResendOtpLoaded extends RegResendOtpState {
  @override
  List<Object> get props => [];

  final RegResendOtpModel regResendOtpModel;
  const RegResendOtpLoaded(this.regResendOtpModel);
}
