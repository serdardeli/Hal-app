import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_musteri_state.dart';

class AddMusteriCubit extends Cubit<AddMusteriState> {
  AddMusteriCubit() : super(AddMusteriInitial());
}
