part of 'get_profile_bloc.dart';

sealed class GetProfileState extends Equatable {
  const GetProfileState();
}

final class GetProfileInitial extends GetProfileState {
  @override
  List<Object> get props => [];
}

class GetProfileLoading extends GetProfileState {
  @override

  List<Object> get props => [];
}

class GetProfileLoaded extends GetProfileState {
  @override
  List<Object> get props => [];

  final GetProfileModel getProfileModel;
  const GetProfileLoaded(this.getProfileModel);
}

class GetProfileError extends GetProfileState {
  late final String? message;
  GetProfileError(this.message);

  @override
  List<Object> get props => [];
}
