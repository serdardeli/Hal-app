import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/driver/sub/view/add_driver.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/driver/sub/viewmodel/cubit/add_driver_cubit.dart';
import 'package:hal_app/project/cache/driver_list_cache_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';

import '../../../../../../../project/model/driver_model/driver_model.dart';
import '../../../../../../helper/active_tc.dart';

class DriverGeneral extends StatelessWidget {
  static const String name = "driverGeneral";
  const DriverGeneral({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildDriverEkleFloatingActionButton(context),
        ],
      ),
      appBar: const CupertinoNavigationBar(
        middle: Text("Eklenen Sürücüler"),
      ),
      body: buildDriverBody(context),
    );
  }

  FloatingActionButton buildDriverEkleFloatingActionButton(
      BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: "surucuEkle",
        backgroundColor: Colors.green,
        onPressed: () {
          context.read<AddDriverCubit>().setIsUpdate(false);
          context.read<AddDriverCubit>().clearAllInfos();
          Navigator.pushNamed(context, AddDriverPage.name);
        },
        label: const Text("Sürücü Ekle"));
  }

  Padding buildDriverBody(BuildContext context) {
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
                  Hive.box<List<dynamic>>(DriverListCacheManager.instance.key)
                      .listenable(),
              builder: (BuildContext context, Box<List<dynamic>>? box,
                  Widget? child) {
                List<dynamic>? driverMap = DriverListCacheManager.instance
                    .getItem(ActiveTc.instance.activeTc);
                List<DriverModel> driverList = [];
                if (driverMap != null) {
                  for (var element in driverMap) {
                    DriverModel elementFromDb = DriverModel.fromJson(
                        Map<String, dynamic>.from(element));
                    driverList.add(elementFromDb);
                  }
                }
                if (driverList.ext.isNotNullOrEmpty) {
                  driverList = listToShowTransactions(driverList, context);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: driverList.length,
                    itemBuilder: (context, index) {
                      DriverModel driver = driverList[index];

                      return buildListItem(context, driver);
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

  List<DriverModel> listToShowTransactions(
      List<DriverModel> coinListToShow, BuildContext context) {
    coinListToShow = searchTransaction(context, coinListToShow);

    return coinListToShow;
  }

  List<DriverModel> searchTransaction(
      BuildContext context, List<DriverModel> coinListToShow) {
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

  InkWell buildListItem(BuildContext context, DriverModel driver) {
    return InkWell(
      onTap: () {
        context.read<AddDriverCubit>().setIsUpdate(true);
        context.read<AddDriverCubit>().fillDriverData(driver);
        Navigator.pushNamed(context, AddDriverPage.name);
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
                child: Text((driver.userName)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
