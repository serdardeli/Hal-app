import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'remove_excess_tc_state.dart';

class RemoveExcessTcCubit extends Cubit<RemoveExcessTcState> {
  RemoveExcessTcCubit() : super(RemoveExcessTcInitial());
}
