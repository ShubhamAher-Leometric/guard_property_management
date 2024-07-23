part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  ChangePasswordEvent();
  @override
  List<Object> get props => [];
}
class ChangePasswordData extends ChangePasswordEvent {
  final String newPasswordData;
  ChangePasswordData(this.newPasswordData);
}