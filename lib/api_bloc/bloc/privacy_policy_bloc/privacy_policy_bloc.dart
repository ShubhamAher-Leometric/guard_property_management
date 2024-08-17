import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/privacypolicymodel.dart';
import '../../repository/PrivacyPolicyRepository.dart';

part 'privacy_policy_event.dart';
part 'privacy_policy_state.dart';

class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  PrivacyPolicyBloc() : super(PrivacyPolicyInitial()) {
    final PrivacyPolicyrepository _apiRepository = PrivacyPolicyrepository();

    on<PrivacyPolicyEvent>((event, emit) async {
      try {
        emit(PrivacyPolicyLoading());
        final mList = await _apiRepository.privacyPolicyData();
        emit(PrivacyPolicyLoaded(mList));
        if (mList.error != null) {
          emit(PrivacyPolicyError(mList.error));
        }
      } on NetworkError {
        emit(PrivacyPolicyError(
            "Failed to fetch data. is your device online?"));
      }      });
  }
}
