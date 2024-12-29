import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import '../../../../../project/utils/widgets/build_text_form_field_with_animation.dart';
import '../../../../helper/active_tc.dart';
import '../../add_musteri/view/add_musteri_general.dart';
import '../sub/add_profile/view/add_uretici_profile.dart';
import '../viewmodel/cubit/add_profile_cubit.dart';
import '../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../project/model/bildirimci/bildirimci_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

import '../../../../../project/cache/uretici_list_cache_manager.dart';
import '../../../../../project/model/uretici_model/uretici_model.dart';
import '../../bildirim_page/main_bildirim_page/viewmodel/cubit/main_bildirim_cubit.dart';
import '../viewmodel/cubit/add_profile_page_general_cubit.dart';

class AddProfilePage extends StatelessWidget {
  static const name = "addProfilePage";

  AddProfilePage({Key? key}) : super(key: key);
  final List<Uretici> searchresult = [];

  static const int index = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: BlocBuilder<AddProfileCubit, AddProfileState>(
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: const SizedBox(),
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                        tabs: [
                          Tab(
                              child: Text("Üretici",
                                  style: context.general.textTheme.bodyLarge
                                      ?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                          Tab(
                              child: Text("Müşteri",
                                  style: context.general.textTheme.bodyLarge
                                      ?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    buildUreticiBody(context),
                    const AddMusteriGeneral()
                  ],
                ));
          },
        ),
      ),
    );
  }

  Scaffold buildUreticiBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildUreticiEkleFloatingActionButton(context),
        ],
      ),
      body: Padding(
        padding: context.padding.horizontalLow,
        child: Column(
          children: [
            BlocBuilder<AddProfilePageGeneralCubit, AddProfilePageGeneralState>(
                builder: (context, state) {
              return buildTextFormFieldWithAnimation(
                context,
                controller: context
                    .read<AddProfilePageGeneralCubit>()
                    .searchTextEditingController,
                focusNode:
                    context.watch<AddProfilePageGeneralCubit>().myFocusNode,
                isSearchOpen:
                    context.watch<AddProfilePageGeneralCubit>().isSearchOpen,
                onChanged: () {
                  context.read<AddProfileCubit>().emitInitialState();
                },
              );
            }),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<List<dynamic>>(
                        UreticiListCacheManager.instance.key)
                    .listenable(),
                builder: (BuildContext context, Box<List<dynamic>>? box,
                    Widget? child) {
                  List<dynamic>? ureticiMap = UreticiListCacheManager.instance
                      .getItem(ActiveTc.instance.activeTc);
                  List<Uretici> ureticiList = [];
                  if (ureticiMap != null) {
                    for (var element in ureticiMap) {
                      Uretici elementFromDb =
                          Uretici.fromJson(Map<String, dynamic>.from(element));
                      ureticiList.add(elementFromDb);
                    }
                  }
                  if (ureticiList.ext.isNotNullOrEmpty) {
                    ureticiList = listToShowTransactions(ureticiList, context);
                    return ListView.builder(
                      itemCount: ureticiList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: context.padding.verticalLow,
                            child: Text(
                              "Eklenen Üreticiler ",
                              textAlign: TextAlign.center,
                              style: context.general.textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          );
                        }

                        Uretici uretici = ureticiList[index - 1];

                        return buildListItem(context, uretici);
                      },
                    );
                  }
                  return const Center(child: Text("Henüz üretici eklemediniz"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Uretici> listToShowTransactions(
      List<Uretici> coinListToShow, BuildContext context) {
    coinListToShow = searchTransaction(context, coinListToShow);

    return coinListToShow;
  }

  List<Uretici> searchTransaction(
      BuildContext context, List<Uretici> coinListToShow) {
    if (context.read<AddProfilePageGeneralCubit>().isSearchOpen &&
        context
                .read<AddProfilePageGeneralCubit>()
                .searchTextEditingController
                .text !=
            "") {
      coinListToShow = searchResult(coinListToShow, context);
    }
    return coinListToShow;
  }

  List<Uretici> searchResult(List<Uretici> list, BuildContext context) {
    searchresult.clear();

    for (int i = 0; i < list.length; i++) {
      String data = (list[i].ureticiAdiSoyadi);
      if (data.toLowerCaseTr().contains(context
          .read<AddProfilePageGeneralCubit>()
          .searchTextEditingController
          .text
          .toLowerCase())) {
        searchresult.add(list[i]);
      }
    }
    return searchresult;
  }

  Widget buildChooseTcDropDown(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<Bildirimci>(BildirimciCacheManager.instance.key)
                .listenable(),
        builder: (context, Box<Bildirimci>? box, children) {
          List<String>? bildirimciTcList = box?.keys.toList().cast<String>();
          if (bildirimciTcList == null || bildirimciTcList.isEmpty) {
            return const Text("Hata");
          }
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              dropdownStyleData: DropDown2Style.dropdownStyleData(context),
              buttonStyleData: DropDown2Style.buttonStyleData(context),
              hint: Text('Bildirimci Seç',
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).hintColor)),
              items: bildirimciTcList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: context.general.textTheme.titleLarge,
                        ),
                      ))
                  .toList(),
              value: ActiveTc.instance.activeTc,
              onChanged: (value) async {
                ActiveTc.instance.activeTc = value as String;
                await context
                    .read<MainBildirimCubit>()
                    .assignRightUser(value, context);
                context.read<AddProfileCubit>().emitInitialState();
              },

              //This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  //   context.read<SatinAlimCubit>().malinAdiController.clear();
                }
              },
            ),
          );
        });
  }

  FloatingActionButton buildUreticiEkleFloatingActionButton(
      BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: "üretici ekle",
        backgroundColor: Colors.green,
        onPressed: () {
          //    Navigator.push(context,MaterialPageRoute(builder: (context) =>  AddUreticiProfilePage(),maintainState: false,fullscreenDialog: true));

          context.read<AddProfileCubit>().setIsUpdate(false);
          Navigator.pushNamed(context, AddUreticiProfilePage.name);
        },
        label: const Text("Üretici Ekle"));
  }

  InkWell buildListItem(BuildContext context, Uretici uretici) {
    return InkWell(
      onTap: () {
        context.read<AddProfileCubit>().setIsUpdate(true);
        context.read<AddProfileCubit>().fillUreticiData(uretici);
        Navigator.pushNamed(context, AddUreticiProfilePage.name);
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
              child: ListTile(
                textColor: Colors.green[800],
                title: Text((uretici.ureticiAdiSoyadi)),
                subtitle: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: context.padding.horizontalLow * .5,
                        child: Text((uretici.ureticiIlAdi),
                            style: context.general.textTheme.bodySmall?.apply(),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: context.padding.horizontalLow * .5,
                        child: Text((uretici.ureticiIlceAdi),
                            style: context.general.textTheme.bodySmall?.apply(),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: context.padding.horizontalLow * .5,
                        child: Text((uretici.ureticiBeldeAdi),
                            style: context.general.textTheme.bodySmall?.apply(),
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
