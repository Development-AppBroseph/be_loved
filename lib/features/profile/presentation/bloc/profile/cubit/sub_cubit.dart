import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/profile/domain/usecases/get_status_sub.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_state.dart';
import 'package:bloc/bloc.dart';

class SubCubit extends Cubit<SubState> {
  final GetStatusSub getStatusSub;

  SubCubit({required this.getStatusSub}) : super(SubEmptyState());

  Future<void> getStatus() async {
    try {
      final result = await getStatusSub.call(NoParams());
      result.fold((error) => emit(SubNotHaveState()), (done) {
        if (done.haveSub) {
          emit(SubHaveState());
        } else {
          emit(SubNotHaveState());
        }
      });
    } catch (e) {
      emit(SubNotHaveState());
    }
  }
}
