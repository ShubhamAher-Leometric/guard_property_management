part of 'visitor_listing_bloc.dart';

sealed class VisitorListingState extends Equatable {
  const VisitorListingState();
}

final class VisitorListingInitial extends VisitorListingState {
  @override
  List<Object> get props => [];
}

class VisitorListingLoading extends VisitorListingState {
  @override
  List<Object> get props => [];
}

class VisitorListingLoaded extends VisitorListingState {
  @override
  List<Object> get props => [];
  final VistorListingModel vistorListingModel;
  const VisitorListingLoaded(this.vistorListingModel);
}

class VisitorListingError extends VisitorListingState {
  late final String? message;
  VisitorListingError(this.message);
  @override
  List<Object> get props => [];
}
