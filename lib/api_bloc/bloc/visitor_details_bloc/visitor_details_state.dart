part of 'visitor_details_bloc.dart';

sealed class VisitorDetailsState extends Equatable {
  const VisitorDetailsState();
}

final class VisitorDetailsInitial extends VisitorDetailsState {
  @override
  List<Object> get props => [];
}

class VisitorDetailsLoading extends VisitorDetailsState {
  @override
  List<Object> get props => [];
}

class VisitorDetailsError extends VisitorDetailsState {
  late final String? message;
  VisitorDetailsError(this.message);

  @override
  List<Object> get props => [];
}

class VisitorDetailsLoaded extends VisitorDetailsState {
  @override
  List<Object> get props => [];

  final VisitorDetailsModel visitorDetailsModel;
  const VisitorDetailsLoaded(this.visitorDetailsModel);
}
