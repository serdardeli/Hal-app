import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/add_musteri/sub/viewmodel/cubit/add_musteri_sub_cubit.dart';
import 'package:hal_app/project/cache/musteri_list_cache_manager.dart';
import 'package:hal_app/project/model/musteri_model/musteri_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';

import '../../../../helper/active_tc.dart';
import '../sub/view/add_musteri_sub.dart';

class AddMusteriGeneral extends StatelessWidget {
  const AddMusteriGeneral({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildUreticiEkleFloatingActionButton(context),
        ],
      ),
      body: buildUreticiBody(context),
    );
  }

  FloatingActionButton buildUreticiEkleFloatingActionButton(
      BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: "musteriEkle",
        backgroundColor: Colors.green,
        onPressed: () {
          //    Navigator.push(context,MaterialPageRoute(builder: (context) =>  AddUreticiProfilePage(),maintainState: false,fullscreenDialog: true));

          context.read<AddMusteriSubCubit>().setIsUpdate(false);
          context.read<AddMusteriSubCubit>().clearAllInfos();
          Navigator.pushNamed(context, AddMusteriSub.name);
        },
        label: const Text("Müşteri Ekle"));
  }

  Padding buildUreticiBody(BuildContext context) {
    return Padding(
      padding: context.padding.horizontalLow,
      child: Column(
        children: [
          // BlocBuilder<Add, AddProfilePageGeneralState>(
          //     builder: (context, state) {
          //   return buildTextFormFieldWithAnimation(
          //     context,
          //     controller: context
          //         .read<AddProfilePageGeneralCubit>()
          //         .searchTextEditingController,
          //     focusNode:
          //         context.watch<AddProfilePageGeneralCubit>().myFocusNode,
          //     isSearchOpen:
          //         context.watch<AddProfilePageGeneralCubit>().isSearchOpen,
          //     onChanged: () {
          //       context.read<AddProfileCubit>().emitInitialState();
          //     },
          //   );
          // }),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<List<dynamic>>(MusteriListCacheManager.instance.key)
                      .listenable(),
              builder: (BuildContext context, Box<List<dynamic>>? box,
                  Widget? child) {
                List<dynamic>? ureticiMap = MusteriListCacheManager.instance
                    .getItem(ActiveTc.instance.activeTc);
                List<Musteri> ureticiList = [];
                if (ureticiMap != null) {
                  for (var element in ureticiMap) {
                    Musteri elementFromDb =
                        Musteri.fromJson(Map<String, dynamic>.from(element));
                    ureticiList.add(elementFromDb);
                  }
                }
                if (ureticiList.ext.isNotNullOrEmpty) {
                  ureticiList = listToShowTransactions(ureticiList, context);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: ureticiList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: context.padding.verticalLow,
                          child: Text(
                            "Eklenen Müşteriler ",
                            textAlign: TextAlign.center,
                            style: context.general.textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      Musteri uretici = ureticiList[index - 1];

                      return buildListItem(context, uretici);
                    },
                  );
                }
                return Center(
                    child: Padding(
                  padding: context.padding.verticalNormal,
                  child: const Text("Henüz müşteri eklemediniz"),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Musteri> listToShowTransactions(
      List<Musteri> coinListToShow, BuildContext context) {
    coinListToShow = searchTransaction(context, coinListToShow);

    return coinListToShow;
  }

  List<Musteri> searchTransaction(
      BuildContext context, List<Musteri> coinListToShow) {
    // if (context.read<AddProfilePageGeneralCubit>().isSearchOpen &&
    //     context
    //             .read<AddProfilePageGeneralCubit>()
    //             .searchTextEditingController
    //             .text !=
    //         "") {
    //   coinListToShow = searchResult(coinListToShow, context);
    // }
    return coinListToShow;
  }

  InkWell buildListItem(BuildContext context, Musteri musteri) {
    return InkWell(
      onTap: () {
        context.read<AddMusteriSubCubit>().setIsUpdate(true);
        context.read<AddMusteriSubCubit>().fillMusteriData(musteri);
        Navigator.pushNamed(context, AddMusteriSub.name);
      },
      child: Padding(
        padding: context.padding.verticalLow,
        child: Container(
          //   decoration: BoxDecoration(border: Border.all(color: Colors.red),borderRadius: BorderRadius.circular(10)),

          child: Material(
            elevation: 10,
            shadowColor: Colors.green[300],
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green[600]!),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: context.padding.normal,
                child: Text((musteri.musteriAdiSoyadi)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
