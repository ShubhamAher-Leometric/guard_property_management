part of 'get_profile_bloc.dart';

sealed class GetProfileEvent extends Equatable {
  const GetProfileEvent();
  @override
  List<Object> get props => [];
}

class GetProfileDataEvent extends GetProfileEvent {
  GetProfileDataEvent();
}