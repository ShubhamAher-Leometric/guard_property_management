import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/getprofilemodel.dart';
import '../../repository/GetProfileRepository.dart';


part 'get_profile_event.dart';
part 'get_profile_state.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  final GetProfileRepository _apiRepository = GetProfileRepository();

  GetProfileBloc() : super(GetProfileInitial()) {
    on<GetProfileDataEvent>((event, emit) async {
      try {
        emit(GetProfileLoading());
        final mList = await _apiRepository.profileData();
        emit(GetProfileLoaded(mList));
        if (mList.error != null) {
          emit(GetProfileError(mList.error));
        }
      } on NetworkError {
        emit(GetProfileError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
