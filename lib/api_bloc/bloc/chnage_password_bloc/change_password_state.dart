part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

final class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordLoading extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordError extends ChangePasswordState {
  late final String? message;
  ChangePasswordError(this.message);

  @override
  List<Object> get props => [];
}

class ChangePasswordLoaded extends ChangePasswordState {
  @override
  List<Object> get props => [];

  final ChangePasswordModel changePasswordModel;
  const ChangePasswordLoaded(this.changePasswordModel);
}
