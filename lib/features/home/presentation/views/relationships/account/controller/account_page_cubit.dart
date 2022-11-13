import 'package:be_loved/features/home/domain/usecases/post_number.dart';
import 'package:be_loved/features/home/domain/usecases/put_code.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/controller/account_page_state.dart';
import 'package:bloc/bloc.dart';

class AccountCubit extends Cubit<AccountPageState> {
  final PostNumber postNumber;
  final PutCode putCode;

  AccountCubit({required this.postNumber, required this.putCode})
      : super(AccountEmptytPageState());

  Future<void> postPhoneNumber(String phoneNumber) async {
    try {
      final postNumberOrFailure = await postNumber.call(PhoneNumberParams(
        phoneNumber: phoneNumber,
      ));
      postNumberOrFailure.fold(
        (error) => emit(AccountGetErrorPageState(message: "Error")),
        (right) => emit(
          AccountGetResponsePageState(),
        ),
      );
    } catch (e) {
      emit(
        AccountGetErrorPageState(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> putUserCode(int code) async {
    try {
      emit(AccountEmptytPageState());
      final putCodeOrFailure = await putCode.call(CodeParams(code: code));
      putCodeOrFailure.fold(
        (error) => emit(AccountGetErrorPageState(message: "Error")),
        (right) => emit(
          AccountGetCodeResponsePageState(),
        ),
      );
    } catch (e) {
      emit(
        AccountGetErrorPageState(
          message: e.toString(),
        ),
      );
    }
  }
}
