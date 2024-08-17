part of 'terms_and_conditions_bloc.dart';

sealed class TermsAndConditionsState extends Equatable {
  const TermsAndConditionsState();
}

final class TermsAndConditionsInitial extends TermsAndConditionsState {
  @override
  List<Object> get props => [];
}

class TermsAndConditionsLoading extends TermsAndConditionsState {
  @override

  List<Object> get props => [];
}

class TermsAndConditionsLoaded extends TermsAndConditionsState {
  @override
  List<Object> get props => [];

  final TermsAndConditionsModel termsandconditionsModel;
  const TermsAndConditionsLoaded(this.termsandconditionsModel);
}

class TermsAndConditionsError extends TermsAndConditionsState {
  late final String? message;
  TermsAndConditionsError(this.message);

  @override
  List<Object> get props => [];
}
