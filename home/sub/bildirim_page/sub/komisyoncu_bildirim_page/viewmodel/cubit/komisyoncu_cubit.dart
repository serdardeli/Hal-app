import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'komisyoncu_state.dart';

class KomisyoncuCubit extends Cubit<KomisyoncuState> {
  KomisyoncuCubit() : super(KomisyoncuSevkAlim());

  Map<String, String> komisyoncuBildirimTypes = {
    "206": "Sevk Alım",
    "197": "Satış",
    "196": "Sevk Etme",
  };
  String bildirimType = "Sevk Alım";

  String bildirimId = "206";

  void bildirimTypeSelected() {
    if (bildirimType == "Sevk Alım") {
      bildirimId = "206";
      emit(KomisyoncuSevkAlim());
    } else if (bildirimType == "Satış") {
      bildirimId = "197";
      emit(KomisyoncuSatis());
    } else if (bildirimType == "Sevk Etme") {
      bildirimId = "196";
      emit(KomisyoncuSevkEtme());
    } else {
      bildirimId = "197";
      emit(KomisyoncuSatis());
    }
  }

  void bildirimRepeat() {
    bildirimType = "Sevk Alım";
    bildirimTypeSelected();
  }
}
