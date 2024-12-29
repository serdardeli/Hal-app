// dropdown done

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/project/utils/component/dropdown2_driver_search.dart';
import 'package:hal_app/project/utils/component/dropdown2_string_search.dart';
import 'package:hal_app/project/utils/component/dropdown2_uretici_search.dart';

import '../../../../../../../project/cache/depo_cache_manager.dart';
import '../../../../../../../project/cache/driver_list_cache_manager.dart';
import '../../../../../../../project/cache/hal_ici_isyeri_cache_manager.dart';
import '../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../project/cache/sube_cache_manager.dart';
import '../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../project/model/depo/depo_model.dart';
import '../../../../../../../project/model/driver_model/driver_model.dart';
import '../../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../project/model/sube/sube_model.dart';
import '../../../../../../../project/model/uretici_model/uretici_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

import '../../../../../../../project/cache/uretici_list_cache_manager.dart';
import '../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../helper/active_tc.dart';
import '../../../../../../helper/scaffold_messager.dart';
import '../viewmodel/cubit/ureticiden_sevk_alim_cubit.dart';

class UreticiSevkAlimBildirimPage extends StatelessWidget {
  static const name = "ureticiSevkAlimBildirimPage";
  const UreticiSevkAlimBildirimPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      listener: blocListener,
      builder: (context, state) {
        return Padding(
          padding: context.padding.horizontalLow,
          child: Form(
            key: context.read<UreticidenSevkAlimCubit>().formKey,
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(child: buildToplamaMal()),
                    Expanded(
                      child: buildUreticiAdiField2(context),
                    )
                  ],
                ),

                buildIkinciKisiBilgilerField(),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                            padding: context.padding.low,
                            child: buildMalinAdiField2(context))),
                    Expanded(
                        child: Padding(
                            padding: context.padding.low,
                            child: buildMalinCinsiField2(context))),
                  ],
                ),

                buildBagAdetKgField(context),

                buildMalinGidecegiYerDropDown(context),

                buildDropDownErrorMessage(),
                buildUrunuListeyeEkleButton(context),
                //   buildTableColumn(),
                buildTable2(context),
                //    SizedBox(height: context.general.mediaSize.height * .3),
              ],
            ),
          ),
        );
      },
    );
  }

  BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>
      buildToplamaMal() {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              activeColor: Colors.green,
              checkColor: Colors.white,
              value: context.read<UreticidenSevkAlimCubit>().isToplamaHal,
              onChanged: (bool? value) {
                context
                    .read<UreticidenSevkAlimCubit>()
                    .toplamaMalSelected(value!);
              },
            ),
            const Text("Toplama mal")
          ],
        );
      },
    );
  }

  BlocBuilder buildMalinGidecegiYerDropDown(BuildContext context) {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        List<GidecegiYer> gidecegiYerList = [];
        List<Sube> subeler =
            SubelerCacheManager.instance.getItem(ActiveTc.instance.activeTc);
        List<Depo> depolar =
            DepolarCacheManager.instance.getItem(ActiveTc.instance.activeTc);
        List<HalIciIsyeri> halIciIsyerleri = HalIciIsyeriCacheManager.instance
            .getItem(ActiveTc.instance.activeTc);
        if ((subeler.length + depolar.length + halIciIsyerleri.length) == 0) {
          return const Text(
            "Gidilecek yer bulunumadı lütfen ayarlardan kullanıcı bilgilerini güncelleyiniz",
            style: TextStyle(color: Colors.red),
          );
        } else if ((subeler.length + depolar.length + halIciIsyerleri.length) ==
            1) {
          for (var element in subeler) {
            context.read<UreticidenSevkAlimCubit>().gidecegiYer = GidecegiYer(
                type: "Şube",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.subeId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in depolar) {
            context.read<UreticidenSevkAlimCubit>().gidecegiYer = GidecegiYer(
                type: "Depo",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.depoId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in halIciIsyerleri) {
            context.read<UreticidenSevkAlimCubit>().gidecegiYer = GidecegiYer(
                type: "Hal içi işyeri",
                name: element.isyeriAdi.toString(),
                isletmeTuru: element.isletmeTuruAdi,
                isletmeTuruId: element.isletmeTuruId,
                isyeriId: element.isyeriId ?? "null",
                adres: element.halAdi.toString());
          }

          return const SizedBox();
        } else {
          for (var element in subeler) {
            gidecegiYerList.add(GidecegiYer(
                type: "Şube",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.subeId ?? "null",
                adres: element.adres.toString()));
          }
          for (var element in depolar) {
            gidecegiYerList.add(GidecegiYer(
                type: "Depo",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.depoId ?? "null",
                adres: element.adres.toString()));
          }
          for (var element in halIciIsyerleri) {
            gidecegiYerList.add(GidecegiYer(
                type: "Hal içi işyeri",
                name: element.isyeriAdi.toString(),
                isletmeTuru: element.isletmeTuruAdi,
                isletmeTuruId: element.isletmeTuruId,
                isyeriId: element.isyeriId ?? "null",
                adres: element.halAdi.toString()));
          }
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            dropdownStyleData: DropDown2Style.dropdownStyleData(context,
                width: context.general.mediaSize.width * .9),
            buttonStyleData: DropDown2Style.buttonStyleData(context,
                width: context.general.mediaSize.width * .9),
            hint: Text('Gidilecek Yer Seç',
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).hintColor)),
            items: gidecegiYerList
                .map((item) => DropdownMenuItem<GidecegiYer>(
                      value: item,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("  ${item.type}  ${item.isletmeTuru}"),
                          Text(
                            "   ${item.name}",
                            style: const TextStyle(
                                fontSize: 14, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            value: context.read<UreticidenSevkAlimCubit>().gidecegiYer,
            onChanged: (value) {
              context.read<UreticidenSevkAlimCubit>().gidecegiYer =
                  (value as GidecegiYer);
            },
          ),
        );
      },
    );
  }

  Padding buildUrunuListeyeEkleButton(BuildContext context) {
    return Padding(
      padding: context.padding.horizontalHigh,
      child: Padding(
        padding: context.padding.verticalNormal,
        child: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            heroTag: "Ürünü Listeye Ekle",
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              context
                  .read<UreticidenSevkAlimCubit>()
                  .activateAutoValidateMode();
              var result = context
                  .read<UreticidenSevkAlimCubit>()
                  .checkDropDownFieldHasError();
              if (context
                      .read<UreticidenSevkAlimCubit>()
                      .formKey
                      .currentState!
                      .validate() &&
                  !result) {
                context
                    .read<UreticidenSevkAlimCubit>()
                    .disableAutoValidateMode();

                context.read<UreticidenSevkAlimCubit>().urunEkle();
              }
            },
            label: const Text("Ürünü Listeye Ekle")),
      ),
    );
  }

  BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>
      buildDropDownErrorMessage() {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return context.read<UreticidenSevkAlimCubit>().dropDownErrorMessage ==
                ""
            ? const SizedBox()
            : Padding(
                padding: context.padding.verticalLow,
                child: Text(
                  context.read<UreticidenSevkAlimCubit>().dropDownErrorMessage,
                  style: context.general.textTheme.bodyMedium!.apply(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }

  void blocListener(BuildContext context, UreticidenSevkAlimState state) {
    if (state is UreticiSevkAlimLoading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
        ..loadingStyle = EasyLoadingStyle.light
        ..userInteractions = false;
      EasyLoading.show(status: 'HKS Bekleniyor...');
    } else {
      EasyLoading.dismiss();
    }
    if (state is UreticiSevkAlimError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is UreticiSevkAlimSuccessHasSomeError) {
      if (state.response.kayitCevapList == null) {}
      List<Widget> basarili =
          buildSuccessfulTexts(state.response.kayitCevapList!, context);
      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            context.read<UreticidenSevkAlimCubit>().clearFaturaInfo();
          },
          btnOkOnPress: () async {
            context.read<UreticidenSevkAlimCubit>().clearFaturaInfo();

            await context
                .read<UreticidenSevkAlimCubit>()
                .shareWithWhatsapp(state.response);
          },
          context: context,
          dialogType: DialogType.error,
          body: Center(
            child: Column(
              children: [
                Text(
                  "Başarız Künyeler ",
                  style: context.general.textTheme.titleLarge,
                ),

                ...buildErrorTexts(state.response.kayitCevapList!, context),
                basarili.isNotEmpty
                    ? Text(
                        "Başarılı Künyeler ",
                        style: context.general.textTheme.titleLarge,
                      )
                    : const SizedBox(),
                ...basarili,
                Padding(
                  padding: context.padding.low * 1.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "E-Müstahsil  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "E-İrsaliye  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context
                                  .read<UreticidenSevkAlimCubit>()
                                  .isIrsaliyeKesSuccess
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const Text(
                        "E-Fatura  ",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )

                // state.response.kayitCevapList.state.response.message != null
                //     ? Text(state.response.message!.first)
                //     : const SizedBox(),
              ],
            ),
          )).show();

      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, "Bildirim başarısız");
    }
    if (state is UreticiSevkAlimCompletelySuccessful) {
      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            context.read<UreticidenSevkAlimCubit>().clearFaturaInfo();
          },
          btnOkOnPress: () async {
            context.read<UreticidenSevkAlimCubit>().clearFaturaInfo();

            //  Navigator.pop(context);
            await context
                .read<UreticidenSevkAlimCubit>()
                .shareWithWhatsapp(state.response);
          },
          context: context,
          dialogType: DialogType.success,
          body: Center(
            child: Column(
              children: [
                Text(
                  "İşlem Başarılı",
                  style: context.general.textTheme.titleLarge,
                ),
                //  Text(
                //    "Başarılı Künyeler ",
                //    style: context.general.textTheme.headline6,
                //  ),
                ...buildSuccessfulTexts(
                    state.response.kayitCevapList!, context),
                Padding(
                  padding: context.padding.low * 1.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "E-Müstahsil  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "E-İrsaliye  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context
                                  .read<UreticidenSevkAlimCubit>()
                                  .isIrsaliyeKesSuccess
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const Text(
                        "E-Fatura  ",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
                // state.response.kayitCevapList.state.response.message != null
                //     ? Text(state.response.message!.first)
                //     : const SizedBox(),
              ],
            ),
          )).show();
      ScaffoldMessengerHelper.instance
          .showSuccessfulSnackBar(context, "Bildirim başarılı");
    }
  }

  BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState> buildTable2(
      BuildContext context) {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return context
                .watch<UreticidenSevkAlimCubit>()
                .urunList
                .ext
                .isNullOrEmpty
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    height: 50 +
                        (context
                                .read<UreticidenSevkAlimCubit>()
                                .urunList
                                .length *
                            60),
                    child: DataTable2(
                        dataRowHeight: 60,
                        headingRowHeight: 50,
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        // minWidth: 600,
                        showBottomBorder: true,
                        columns: const [
                          DataColumn2(
                            label: Text('Ürün Adı'),
                            // size: ColumnSize.L,
                          ),
                          DataColumn(
                            label: Text('Miktar'),
                          ),
                          DataColumn2(
                            label: Icon(Icons.delete_forever_outlined,
                                color: Colors.green),
                            fixedWidth: 30,
                            size: ColumnSize.S,
                          ),
                        ],
                        rows: <DataRow>[
                          ...(context
                              .read<UreticidenSevkAlimCubit>()
                              .urunList
                              .map(
                            (e) {
                              Icons.delete;
                              return DataRow(cells: <DataCell>[
                                DataCell(Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.urunAdi,
                                      overflow: TextOverflow.visible,
                                      style: context
                                          .general.textTheme.labelSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      e.urunCinsi,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          context.general.textTheme.labelSmall,
                                    )
                                  ],
                                )),
                                DataCell(Padding(
                                  padding: context.padding.verticalLow,
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.always,
                                    keyboardType: Platform.isAndroid
                                        ? TextInputType.number
                                        : TextInputType.datetime,
                                    maxLines: 1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        value = "0";
                                      }
                                      value = value.replaceAll(",", ".");

                                      if (value.trim() != "") {
                                        if (!context
                                            .read<UreticidenSevkAlimCubit>()
                                            .isNumeric(value.trim())) {
                                          return "rakam ve . , kullanabilirsiniz";
                                        }
                                      }

                                      if (double.parse(value) >= 0) {
                                        e.gonderilmekIstenenMiktar = value;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: context.padding.low,
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              context.sized.normalValue * 3),
                                      hintText:
                                          "${e.urunMiktari} ${e.urunBirimAdi}",
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                )),
                                DataCell(
                                    const Center(
                                        child: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.green,
                                    )), onTap: () {
                                  context
                                      .read<UreticidenSevkAlimCubit>()
                                      .removeFromUrunList(e);
                                })
                              ]);
                            },
                          ).toList()),
                        ]),
                  ),
                  buildAracPlakaField(context),
                  buildFaturaColumn(context),
                  buildDriverMain(context),

                  buildBildirimYapButton(context),
                  // Expanded(child: SizedBox())
                ],
              );
      },
    );
  }

  Widget buildDriverMain(BuildContext context) {
    return !context.read<UreticidenSevkAlimCubit>().isIrsaliye
        ? const SizedBox()
        : Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      !context.read<UreticidenSevkAlimCubit>().isSurucuManual
                          ? buildDriverDropDown(context)
                          : const SizedBox(),
                      buildeEnterDriverInfos(context),
                    ],
                  )
                ],
              ),
              buildDriverForm(context),
            ],
          );
  }

  Widget buildDriverDropDown(BuildContext context) {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return DropDown2DriverSearch(
          controller: context
              .read<UreticidenSevkAlimCubit>()
              .driverAdiControllerForDropDown,
          onChanged: (value) {
            context.read<UreticidenSevkAlimCubit>().selectedDriver = value;
            context.read<UreticidenSevkAlimCubit>().emitInitial();
          },
          selectedValue: context.read<UreticidenSevkAlimCubit>().selectedDriver,
          onMenuStateChange: () {
            context
                .read<UreticidenSevkAlimCubit>()
                .driverAdiControllerForDropDown
                .clear();
          },
        );
      },
    );
  }

  Widget buildDriverForm(BuildContext context) {
    return !context.read<UreticidenSevkAlimCubit>().isSurucuManual
        ? const SizedBox()
        : Form(
            key: context.read<UreticidenSevkAlimCubit>().driverFormKey,
            child: Column(
              children: [
                Padding(
                  padding: context.padding.normal,
                  child: TextFormField(
                    controller: context
                        .read<UreticidenSevkAlimCubit>()
                        .driverIdController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Tc giriniz';
                      }
                      if (!context
                          .read<UreticidenSevkAlimCubit>()
                          .isNumeric(value)) {
                        return "Tc sadece numara içerebilir";
                      }
                      if (value.length <= 9) {
                        return "Tc 9 karaterden küçük olamaz";
                      }
                      return null;
                    }),
                    keyboardType: Platform.isAndroid
                        ? TextInputType.number
                        : TextInputType.datetime,
                    autovalidateMode: context
                        .read<UreticidenSevkAlimCubit>()
                        .isAutoValidateModeForDriver,
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: context.sized.normalValue * 3),
                        labelText: "Sürücü Tc",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                ),
                Padding(
                  padding: context.padding.normal,
                  child: TextFormField(
                    controller: context
                        .read<UreticidenSevkAlimCubit>()
                        .driverNameController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Ad Soyad giriniz';
                      }

                      if (value.length <= 9) {
                        return "En Az 5 karakter giriniz";
                      }
                      return null;
                    }),
                    autovalidateMode: context
                        .read<UreticidenSevkAlimCubit>()
                        .isAutoValidateModeForDriver,
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: context.sized.normalValue * 3),
                        labelText: "Sürücü Adı Soyadı",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                ),
              ],
            ),
          );
  }

  Expanded buildeEnterDriverInfos(BuildContext context) {
    return Expanded(
      child: CheckboxListTile(
        activeColor: Colors.green,
        value: context.read<UreticidenSevkAlimCubit>().isSurucuManual,
        onChanged: (value) {
          context.read<UreticidenSevkAlimCubit>().isSurucuManual = value!;
          context.read<UreticidenSevkAlimCubit>().emitInitial();
        },
        title: Text(
          "Sürücü Bilgilerini Manuel Gir",
          style: context.general.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildFaturaColumn(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<MySoftUserModel>(MySoftUserCacheManager.instance.key)
                .listenable(),
        builder:
            (BuildContext context, Box<MySoftUserModel> box, Widget? child) {
          MySoftUserModel? user = box.get(ActiveTc.instance.activeTc);
          //  context.read<AddMySoftUserCubit>().currentMySoftUser = user;
          if (user != null) {
            return BlocBuilder<UreticidenSevkAlimCubit,
                UreticidenSevkAlimState>(
              builder: (context, state) {
                return SizedBox(
                    width: context.general.mediaSize.width * .5,
                    child: buildIrasaliyeCheckBox(context));
              },
            );
          } else {
            return const SizedBox();
          }
        });
  }

  Widget buildIrasaliyeCheckBox(BuildContext context) {
    return CheckboxListTile(
      value: context.read<UreticidenSevkAlimCubit>().isIrsaliye,
      activeColor: Colors.green,
      onChanged: (value) {
        context.read<UreticidenSevkAlimCubit>().isIrsaliye = value!;
        context.read<UreticidenSevkAlimCubit>().emitInitial();
      },
      title: const Text(
        "İrsaliye Kes",
        textAlign: TextAlign.center,
      ),
    );
  }

  BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>
      buildBagAdetKgField(BuildContext context) {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            enabled: context.read<UreticidenSevkAlimCubit>().selectedMalinAdi !=
                null,
            autovalidateMode:
                context.read<UreticidenSevkAlimCubit>().isAutoValidateMode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Miktar giriniz';
              }
              value = value.replaceAll(",", ".");

              context.read<UreticidenSevkAlimCubit>().isNumeric(value);
              if (!context.read<UreticidenSevkAlimCubit>().isNumeric(value)) {
                return 'rakam ve . , kullanabilirsiniz';
              }
              if (double.parse(value) < 0 || double.parse(value) == 0) {
                return '0 dan büyük olmalı';
              }
              return null;
            },
            controller:
                context.read<UreticidenSevkAlimCubit>().adetBagKgController,
            keyboardType: Platform.isAndroid
                ? TextInputType.number
                : TextInputType.datetime,
            decoration: InputDecoration(
                constraints:
                    BoxConstraints(maxHeight: context.sized.normalValue * 3),
                labelText: context
                            .read<UreticidenSevkAlimCubit>()
                            .malMiktarBirimAdi ==
                        ""
                    ? "Miktarı"
                    : context.read<UreticidenSevkAlimCubit>().malMiktarBirimAdi,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25))),
          ),
        );
      },
    );
  }

  BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>
      buildTableColumn() {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return context
                .read<UreticidenSevkAlimCubit>()
                .urunList
                .ext
                .isNullOrEmpty
            ? const SizedBox()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Eklenen Ürün Listesi",
                      textAlign: TextAlign.center,
                      style: context.general.textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: context.padding.horizontalLow,
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(4),
                        2: FlexColumnWidth(4),
                        3: FlexColumnWidth(2),
                      },
                      border: TableBorder.all(
                          borderRadius: BorderRadius.circular(10)),
                      children: [
                        buildTableHeader(),
                        ...buildTableContents(context)
                      ],
                    ),
                  ),
                  buildBildirimYapButton(context)
                ],
              );
      },
    );
  }

  Padding buildBildirimYapButton(BuildContext context) => Padding(
        padding: context.padding.verticalNormal,
        child: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            heroTag: " Bildirim Yap",
            onPressed: () async {
              context
                  .read<UreticidenSevkAlimCubit>()
                  .activateAutoValidateModeForPlaka();
              if (context.read<UreticidenSevkAlimCubit>().isIrsaliye) {
                if (context.read<UreticidenSevkAlimCubit>().isSurucuManual) {
                  context
                      .read<UreticidenSevkAlimCubit>()
                      .activateAutoValidateModeForDriver();

                  if (context
                      .read<UreticidenSevkAlimCubit>()
                      .driverFormKey
                      .currentState!
                      .validate()) {
                    context.read<UreticidenSevkAlimCubit>().selectedDriver =
                        DriverModel(
                            tc: context
                                .read<UreticidenSevkAlimCubit>()
                                .driverIdController
                                .text
                                .trim(),
                            userName: context
                                .read<UreticidenSevkAlimCubit>()
                                .driverNameController
                                .text
                                .trim()
                                .toUpperCaseTr());
                    if (context
                        .read<UreticidenSevkAlimCubit>()
                        .plakaFormKey
                        .currentState!
                        .validate()) {
                      context
                          .read<UreticidenSevkAlimCubit>()
                          .disableAutoValidateModeForPlaka();
                      await context
                          .read<UreticidenSevkAlimCubit>()
                          .bildirimYap();
                    }
                  }
                } else {
                  if (context.read<UreticidenSevkAlimCubit>().selectedDriver ==
                      null) {
                    context.read<UreticidenSevkAlimCubit>().emitError(
                        "Sürücü Seçiniz ve ya manuel olarak ekleyiniz");
                  } else {
                    if (context
                        .read<UreticidenSevkAlimCubit>()
                        .plakaFormKey
                        .currentState!
                        .validate()) {
                      context
                          .read<UreticidenSevkAlimCubit>()
                          .disableAutoValidateModeForPlaka();
                      await context
                          .read<UreticidenSevkAlimCubit>()
                          .bildirimYap();
                    }
                  }
                  //check selected driver
                }
              } else {
                if (context
                    .read<UreticidenSevkAlimCubit>()
                    .plakaFormKey
                    .currentState!
                    .validate()) {
                  context
                      .read<UreticidenSevkAlimCubit>()
                      .disableAutoValidateModeForPlaka();
                  await context.read<UreticidenSevkAlimCubit>().bildirimYap();
                }
              }
            },
            label: const Text("Bildirim Yap")),
      );

  List<TableRow> buildTableContents(BuildContext context) {
    return context
        .read<UreticidenSevkAlimCubit>()
        .urunList
        .map(
          (e) => TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(e.urunAdi)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(e.urunCinsi)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("${e.urunMiktari} ${e.urunBirimAdi}")),
            ),
            SizedBox(
              height: 35,
              child: IconButton(
                onPressed: () {
                  context.read<UreticidenSevkAlimCubit>().removeFromUrunList(e);
                },
                icon: const Icon(Icons.highlight_remove_outlined),
                padding: EdgeInsets.zero,
              ),
            )
          ]),
        )
        .toList();
  }

  TableRow buildTableHeader() {
    return const TableRow(children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Adı"),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Cinsi"),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Miktarı"),
      ),
      Text("")
    ]);
  }

  Padding buildAracPlakaField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
        builder: (context, state) {
          return Form(
            key: context.read<UreticidenSevkAlimCubit>().plakaFormKey,
            child: TextFormField(
              autovalidateMode: context
                  .read<UreticidenSevkAlimCubit>()
                  .isAutoValidateModeForPlaka,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'lütfen plaka bilgisi giriniz';
                }
                return null;
              }),
              controller:
                  context.read<UreticidenSevkAlimCubit>().plakaController,
              decoration: InputDecoration(
                  constraints:
                      BoxConstraints(maxHeight: context.sized.normalValue * 3),
                  labelText: "Araç Plaka",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget buildUreticiAdiField2(BuildContext context) {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return context.read<UreticidenSevkAlimCubit>().isToplamaHal
            ? const SizedBox()
            : DropDown2UreticiSearch(
                controller: context
                    .read<UreticidenSevkAlimCubit>()
                    .ureticiAdiController,
                onChanged: (value) {
                  if (context
                      .read<UreticidenSevkAlimCubit>()
                      .urunList
                      .isNotEmpty) {
                    ScaffoldMessengerHelper.instance.showErrorSnackBar(context,
                        "Tabloda ürün varken üretici bilgileri değiştirilemez");
                  } else {
                    context.read<UreticidenSevkAlimCubit>().selectedUretici =
                        value;
                    context.read<UreticidenSevkAlimCubit>().ureticiSelected();
                  }
                },
                selectedValue:
                    context.read<UreticidenSevkAlimCubit>().selectedUretici,
                onMenuStateChange: () {
                  context
                      .read<UreticidenSevkAlimCubit>()
                      .ureticiAdiController
                      .clear();
                },
              );
      },
    );
  }

  Widget buildUreticiAdiField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller:
                context.read<UreticidenSevkAlimCubit>().ureticiAdiController,
            decoration: InputDecoration(
                labelText: 'Üretici Adı',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)))),
        suggestionsCallback: (pattern) {
          var list = [];

          context
              .read<UreticidenSevkAlimCubit>()
              .ureticiList
              .forEach((element) {
            if ((element.ureticiAdiSoyadi)
                .toLowerCaseTr()
                .contains(pattern.toLowerCaseTr())) {
              list.add(element.ureticiAdiSoyadi);
            }
          });
          return list;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),
          );
        },
        getImmediateSuggestions: true,
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          context.read<UreticidenSevkAlimCubit>().ureticiAdiController.text =
              suggestion.toString();
          context.read<UreticidenSevkAlimCubit>().ureticiSelected();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a city';
          }
          return null;
        },
        // onSaved: (value) => this._selectedCity = value,
      ),
    );
  }

  BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>
      buildIkinciKisiBilgilerField() {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: context.padding.low,
                  child: buildCityField2(context),
                )),
                Expanded(
                    child: Padding(
                  padding: context.padding.low,
                  child: buildIlceField2(context),
                )),
                Expanded(
                    child: Padding(
                  padding: context.padding.low,
                  child: buildBeldeField2(context),
                )),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildCityField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<UreticidenSevkAlimCubit>().ilController,
      items: context.read<UreticidenSevkAlimCubit>().getCities.values.toList(),
      hint: 'İl Seç',
      onChanged: (value) {
        if (context.read<UreticidenSevkAlimCubit>().urunList.isNotEmpty) {
          ScaffoldMessengerHelper.instance.showErrorSnackBar(
              context, "Tabloda ürün varken üretici bilgileri değiştirilemez");
        } else {
          context.read<UreticidenSevkAlimCubit>().ilSelected(value);
        }
      },
      selectedValue: context.read<UreticidenSevkAlimCubit>().selectedIl,
      onMenuStateChange: () {
        context.read<UreticidenSevkAlimCubit>().ilController.clear();
      },
    );
  }

  Widget buildIlceField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<UreticidenSevkAlimCubit>().ilceController,
      items: context.read<UreticidenSevkAlimCubit>().getIlceler.values.toList(),
      hint: 'İlçe Seç',
      onChanged: (value) {
        if (context.read<UreticidenSevkAlimCubit>().urunList.isNotEmpty) {
          ScaffoldMessengerHelper.instance.showErrorSnackBar(
              context, "Tabloda ürün varken üretici bilgileri değiştirilemez");
        } else {
          context.read<UreticidenSevkAlimCubit>().ilceSelected(value);
        }
      },
      selectedValue: context.read<UreticidenSevkAlimCubit>().selectedIlce,
      onMenuStateChange: () {
        context.read<UreticidenSevkAlimCubit>().ilceController.clear();
      },
    );
  }

  Widget buildBeldeField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<UreticidenSevkAlimCubit>().beldeController,
      items:
          context.read<UreticidenSevkAlimCubit>().getBeldeler.values.toList(),
      hint: 'Belde Seç',
      onChanged: (value) {
        if (context.read<UreticidenSevkAlimCubit>().urunList.isNotEmpty) {
          ScaffoldMessengerHelper.instance.showErrorSnackBar(
              context, "Tabloda ürün varken üretici bilgileri değiştirilemez");
        } else {
          context.read<UreticidenSevkAlimCubit>().selectedBelde = value;
          context.read<UreticidenSevkAlimCubit>().beldeSelected();
        }
      },
      selectedValue: context.read<UreticidenSevkAlimCubit>().selectedBelde,
      onMenuStateChange: () {
        context.read<UreticidenSevkAlimCubit>().beldeController.clear();
      },
    );
  }

  BlocBuilder buildMalinAdiField2(BuildContext context) {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return DropDown2StringSearch(
          controller: context.read<UreticidenSevkAlimCubit>().malinAdiController,
          items: context.read<UreticidenSevkAlimCubit>().getMallar.values.toList(),
          hint: 'Ürün Seç',
          onChanged: (value) {
            context.read<UreticidenSevkAlimCubit>().malinAdiSelected(value);
          },
          selectedValue: context.read<UreticidenSevkAlimCubit>().selectedMalinAdi,
          onMenuStateChange: () {
            context.read<UreticidenSevkAlimCubit>().malinAdiController.clear();
          },
        );
      },
    );
  }

  BlocBuilder buildMalinCinsiField2(BuildContext context) {
    return BlocBuilder<UreticidenSevkAlimCubit, UreticidenSevkAlimState>(
      builder: (context, state) {
        return DropDown2StringSearch(
          items: context.read<UreticidenSevkAlimCubit>().urunCinsiIsimleriList,
          hint: 'Cins Seç',
          onChanged: (value) {
            context.read<UreticidenSevkAlimCubit>().malinCins = value;
            context.read<UreticidenSevkAlimCubit>().malinCinsiSelected();
          },
          selectedValue: context.read<UreticidenSevkAlimCubit>().malinCins,
          onMenuStateChange: () {
            context.read<UreticidenSevkAlimCubit>().malinAdiController.clear();
          },
        );
      },
    );
  }

  List<Widget> buildErrorTexts(
      List<BildirimKayitCevapModel> cevapList, BuildContext context) {
    List<Widget> list = [];
    for (var element in cevapList) {
      if ((element.kunyeNo == "0" || element.kunyeNo == null)) {
        list.add(Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                child: ListTile(
                  trailing: const Icon(Icons.error),
                  title: const Text("Error"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kunye: ${element.kunyeNo ?? "boş künye"}"),
                      Text(
                        "Hata Mesajı: ${element.message ?? "boş mesaj"}",
                        style: context.general.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
      }
    }
    return list;
  }

  List<Widget> buildSuccessfulTexts(
      List<BildirimKayitCevapModel> cevapList, BuildContext context) {
    List<Widget> list = [];
    for (var element in cevapList) {
      if (!(element.kunyeNo == "0" || element.kunyeNo == null)) {
        String malAdi = "";
        context.read<UreticidenSevkAlimCubit>().getMallar.forEach((key, value) {
          if (element.malinId == key) {
            malAdi = value;
          }
        });
        list.add(Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                child: ListTile(
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text("$malAdi \nPlaka: ${element.aracPlakaNo}"),
                  subtitle: Text("Kunye: ${element.kunyeNo ?? "boş künye"}"),
                ),
              ),
            ),
          ],
        ));
      }
    }
    return list;
  }
}
