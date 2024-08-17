part of 'privacy_policy_bloc.dart';

sealed class PrivacyPolicyState extends Equatable {
  const PrivacyPolicyState();
}

final class PrivacyPolicyInitial extends PrivacyPolicyState {
  @override
  List<Object> get props => [];
}

class PrivacyPolicyLoading extends PrivacyPolicyState {
  @override

  List<Object> get props => [];
}

class PrivacyPolicyLoaded extends PrivacyPolicyState {
  @override
  List<Object> get props => [];

  final PrivacyPolicyModel privacyPolicyModel;
  const PrivacyPolicyLoaded(this.privacyPolicyModel);
}

class PrivacyPolicyError extends PrivacyPolicyState {
  late final String? message;
  PrivacyPolicyError(this.message);

  @override
  List<Object> get props => [];
}
