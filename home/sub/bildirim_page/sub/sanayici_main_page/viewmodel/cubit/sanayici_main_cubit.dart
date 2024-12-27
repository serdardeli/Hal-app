import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sanayici_main_state.dart';

class SanayiciMainCubit extends Cubit<SanayiciMainState> {
  SanayiciMainCubit() : super(SanayiciSatinAlim());
  Map<String, String> komisyoncuBildirimTypes = {
    "195": "Satın Alım",
    "197": "Satış",
    "196": "Sevk Etme",
  };
  String bildirimType = "Satın Alım";

  String bildirimId = "195";

  void bildirimTypeSelected() {
    if (bildirimType == "Satın Alım") {
      bildirimId = "195";
      emit(SanayiciSatinAlim());
    } else if (bildirimType == "Satış") {
      bildirimId = "197";
      emit(SanayiciSatis());
    } else if (bildirimType == "Sevk Etme") {
      bildirimId = "196";
      emit(SanayiciSevkEtme());
    } else {
      bildirimId = "195";
      emit(SanayiciSatis());
    }
  }

  void bildirimRepeat() {
    bildirimType = "Satın Alım";
    bildirimTypeSelected();
  }
}
