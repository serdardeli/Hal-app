import 'package:bloc/bloc.dart';
import 'package:hal_app/project/model/mysoft_giden_irsaliye_model.dart/mysoft_giden_irsaliye_model.dart';
import 'package:hal_app/project/service/mysoft/auth/mysoft_auth_service.dart';
import 'package:meta/meta.dart';

import '../../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../../project/model/mysoft_giden_fatura_model/mysoft_giden_fatura_model.dart';
import '../../../../../../../../project/service/mysoft/fatura/mysoft_giden_fatura_service.dart';
import '../../../../../../../helper/active_tc.dart';

part 'giden_fatura_state.dart';

class GidenFaturaCubit extends Cubit<GidenFaturaState> {
  GidenFaturaCubit() : super(GidenFaturaInitial()) {
    fetchFatura();
    fetchIrsaliye();
  }
  List<GidenFaturaData> listOfFatura = [];
  List<GidenIrsaliyeData> listOfIrsaliye = [];

  Future<void> fetchFatura() async {
    var token = await getToken();
    if (token != null) {
      var result =
          await MySoftGidenFaturaService.instance.fetchGidenFatura(token);
      if (result.error != null) {
        emit(GidenFaturaError(message: result.error?.message ?? "Fatura hata"));
        emit(GidenFaturaInitial());
      } else if (result.data != null) {
        listOfFatura = (result.data as List<GidenFaturaData>);
        emit(GidenFaturaInitial());
      } else {
        emit(GidenFaturaError(message: "Data boş"));
        emit(GidenFaturaInitial());
      }
    }
  }

  void emitInitial() {
    emit(GidenFaturaInitial());
  }

  Future<void> fetchIrsaliye() async {
    var token = await getToken();
    if (token != null) {
      var result =
          await MySoftGidenFaturaService.instance.fetchGidenIrsaliye(token);

      if (result.error != null) {
        emit(GidenFaturaError(message: result.error?.message ?? "Fatura hata"));
        emit(GidenFaturaInitial());
      } else if (result.data != null) {
        listOfIrsaliye = (result.data as List<GidenIrsaliyeData>);
        emit(GidenFaturaInitial());
      } else {
        emit(GidenFaturaError(message: "Data boş"));
        emit(GidenFaturaInitial());
      }
    }
  }

  Future<String?> getToken() async {
    MySoftUserModel? usermodel =
        MySoftUserCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (usermodel != null) {
      var result = await MySoftAuthService.instance
          .getToken(usermodel.userName, usermodel.password);

      if (result.error != null) {
        emit(GidenFaturaError(message: result.error!.message));
        emit(GidenFaturaInitial());
      } else if (result.data != null) {
        return result.data;
      } else {
        emit(GidenFaturaError(message: "MySoft hata 1"));
        emit(GidenFaturaInitial());
      }
    } else {
      emit(GidenFaturaError(message: "MySoft Bilgilerini Güncelleyiniz"));
      emit(GidenFaturaInitial());
    }
  }
}
