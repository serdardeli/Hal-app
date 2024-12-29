// dropdown done

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/project/utils/component/dropdown2_driver_search.dart';
import 'package:hal_app/project/utils/component/dropdown2_musteri_search.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:turkish/turkish.dart';
import '../../../../../../../project/cache/depo_cache_manager.dart';
import '../../../../../../../project/cache/driver_list_cache_manager.dart';
import '../../../../../../../project/cache/hal_ici_isyeri_cache_manager.dart';
import '../../../../../../../project/cache/musteri_depo_cache_manager.dart';
import '../../../../../../../project/cache/musteri_hal_ici_isyeri_cache_manager.dart';
import '../../../../../../../project/cache/musteri_list_cache_manager.dart';
import '../../../../../../../project/cache/musteri_sube_cache_manager.dart';
import '../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../project/cache/sube_cache_manager.dart';
import '../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../project/model/depo/depo_model.dart';
import '../../../../../../../project/model/driver_model/driver_model.dart';
import '../../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../project/model/musteri_model/musteri_model.dart';
import '../../../../../../../project/model/sube/sube_model.dart';
import '../../../../../../helper/active_tc.dart';
import '../../../../../../helper/scaffold_messager.dart';
import 'package:kartal/kartal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../viewmodel/cubit/home_cubit.dart';
import '../viewmodel/cubit/sevk_etme_cubit.dart';
import '../../../../../../../project/utils/widgets/dropdown_selection.dart';

import '../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../../project/model/referans_kunye/referans_kunye_model.dart';

class SevkEtmePage extends StatelessWidget {
  const SevkEtmePage({Key? key}) : super(key: key);
  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SevkEtmeCubit, SevkEtmeState>(
      listener: blocListener,
      child: Scaffold(
        body: Form(
          key: context.read<SevkEtmeCubit>().formKey,
          child: SingleChildScrollView(
              child: Column(
            children: [
              ValueListenableBuilder(
                  valueListenable: Hive.box<MySoftUserModel>(
                          MySoftUserCacheManager.instance.key)
                      .listenable(),
                  builder: (BuildContext context, Box<MySoftUserModel> box,
                      Widget? child) {
                    MySoftUserModel? user = box.get(ActiveTc.instance.activeTc);
                    //  context.read<AddMySoftUserCubit>().currentMySoftUser = user;
                    if (user != null) {
                      return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: context.general.mediaSize.width * .7,
                            child: CheckboxListTile(
                              activeColor: Colors.green,
                              value:
                                  context.read<SevkEtmeCubit>().isSevkYourself,
                              onChanged: (value) {
                                context
                                    .read<SevkEtmeCubit>()
                                    .setIsSevkYourSelf = (value ?? false);
                              },
                              title: const Text("Kendi Firmanıza Sevk"),
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),

              buildMusteriAdiField(context),

              buildMalinGidecegiYerDropDown(context),

              // buildSelectedCustomerAdjectiveDropDown(context),

              //  buildUrununGidecegiIsyeriTc(context),
              buildDateField(context),
              sorgulamaAraligiError(),

              buildKunyeSorgulama(context),
              // buildTable(context),
              //  buildTableView2(context),
              buildTable2(context),

              // referansKunyeDropDownOption(),

              SizedBox(height: context.general.mediaSize.height * .3),
            ],
          )),
        ),
      ),
    );
  }

  BlocBuilder buildMalinGidecegiYerDropDownForYourSelf(BuildContext context) {
    return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
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
            context.read<SevkEtmeCubit>().gidecegiYer = GidecegiYer(
                type: "Şube",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.subeId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in depolar) {
            context.read<SevkEtmeCubit>().gidecegiYer = GidecegiYer(
                type: "Depo",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.depoId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in halIciIsyerleri) {
            context.read<SevkEtmeCubit>().gidecegiYer = GidecegiYer(
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
            value: context.read<SevkEtmeCubit>().gidecegiYer,
            onChanged: (value) {
              context.read<SevkEtmeCubit>().gidecegiYer =
                  (value as GidecegiYer);
              context.read<SevkEtmeCubit>().gidecegiYerSelected();
            },
          ),
        );
      },
    );
  }

  BlocBuilder<SevkEtmeCubit, SevkEtmeState> sorgulamaAraligiError() {
    return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
      builder: (context, state) {
        int difference = context
            .read<SevkEtmeCubit>()
            .endDay
            .difference(context.read<SevkEtmeCubit>().startDay)
            .inDays;
        if (difference > 90) {
          return const Text(
            "Sorgulama aralığı 3 aydan büyük olamaz",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget buildDateField(BuildContext context) {
    return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
      builder: (context, state) {
        if (context.read<SevkEtmeCubit>().isSevkYourself) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildStartDate(),
              const Text("   "),
              buildBitisDate(context),
            ],
          );
        }
        return (context.read<SevkEtmeCubit>().selectedMusteri != null &&
                context.read<SevkEtmeCubit>().gidecegiYer != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildStartDate(),
                  const Text("   "),
                  buildBitisDate(context),
                ],
              )
            : const SizedBox();
      },
    );
  }

  Row buildBitisDate(BuildContext context) {
    return Row(
      children: [
        Text("Bitiş: ",
            style: context.general.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
          builder: (context, state) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showDialog(
                  CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime: context.read<SevkEtmeCubit>().endDay,
                    maximumDate: context.read<SevkEtmeCubit>().maxDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      context.read<SevkEtmeCubit>().endDay = newDate;
                      context.read<SevkEtmeCubit>().emitInitialState();
                    },
                  ),
                  context),
              child: Text(
                '${context.read<SevkEtmeCubit>().endDay.day}-${context.read<SevkEtmeCubit>().endDay.month}-${context.read<SevkEtmeCubit>().endDay.year}',
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  BlocBuilder<SevkEtmeCubit, SevkEtmeState> buildStartDate() {
    return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
      builder: (context, state) {
        return Row(
          children: [
            Text("Başlangıç: ",
                style: context.general.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showDialog(
                  CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime: context.read<SevkEtmeCubit>().startDay,
                    maximumDate: context.read<SevkEtmeCubit>().maxDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      context.read<SevkEtmeCubit>().startDay = newDate;
                      context.read<SevkEtmeCubit>().emitInitialState();
                    },
                  ),
                  context),
              child: Text(
                '${context.read<SevkEtmeCubit>().startDay.day}-${context.read<SevkEtmeCubit>().startDay.month}-${context.read<SevkEtmeCubit>().startDay.year}',
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _showDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  Widget buildMalinGidecegiYerDropDown(BuildContext context) {
    return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
      builder: (context, state) {
        if (context.read<SevkEtmeCubit>().isSevkYourself) {
          return buildMalinGidecegiYerDropDownForYourSelf(context);
        }
        if (context.read<SevkEtmeCubit>().selectedMusteri == null) {
          return const SizedBox();
        }

        List<GidecegiYer> gidecegiYerList = [];
        List<Sube> subeler = MusteriSubelerCacheManager.instance
            .getItem(context.read<SevkEtmeCubit>().selectedMusteri!.musteriTc);
        List<Depo> depolar = MusteriDepolarCacheManager.instance
            .getItem(context.read<SevkEtmeCubit>().selectedMusteri!.musteriTc);
        List<HalIciIsyeri> halIciIsyerleri = MusteriHalIciIsyeriCacheManager
            .instance
            .getItem(context.read<SevkEtmeCubit>().selectedMusteri!.musteriTc);
        if ((subeler.length + depolar.length + halIciIsyerleri.length) == 0) {
          return const Text(
            "Gidilecek yer bulunumadı lütfen ayarlardan kullanıcı bilgilerini güncelleyiniz",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          );
        } else if ((subeler.length + depolar.length + halIciIsyerleri.length) ==
            1) {
          for (var element in subeler) {
            context.read<SevkEtmeCubit>().gidecegiYer = GidecegiYer(
                type: "Şube",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.subeId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in depolar) {
            context.read<SevkEtmeCubit>().gidecegiYer = GidecegiYer(
                type: "Depo",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.depoId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in halIciIsyerleri) {
            context.read<SevkEtmeCubit>().gidecegiYer = GidecegiYer(
                type: "Hal içi işyeri",
                name: element.isyeriAdi.toString(),
                isletmeTuru: element.isletmeTuruAdi,
                isletmeTuruId: element.isletmeTuruId,
                isyeriId: element.isyeriId ?? "null",
                adres: element.halAdi.toString());
          }
          context.read<SevkEtmeCubit>().gidecegiYerSelectedSingle();

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

        return Padding(
          padding: context.padding.verticalLow,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<GidecegiYer>(
              isExpanded: true,
              dropdownSearchData: DropdownSearchData(
                searchInnerWidgetHeight: 40,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    controller:
                        context.read<SevkEtmeCubit>().gidecegiYerController,
                    autofocus: true,
                    decoration: InputDecoration(
                      // isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Adress Ara',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchController:
                    context.read<SevkEtmeCubit>().gidecegiYerController,
                searchMatchFn: (item, searchValue) {
                  return ((item.value as GidecegiYer)
                      .name
                      .toString()
                      .toLowerCaseTr()
                      .contains(searchValue.toLowerCaseTr()));
                },
              ),
              dropdownStyleData: DropDown2Style.dropdownStyleData(context,
                  width: context.general.mediaSize.width * .9),
              buttonStyleData: DropDown2Style.buttonStyleData(context,
                  width: context.general.mediaSize.width * .9, height: 70),
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
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              value: context.read<SevkEtmeCubit>().gidecegiYer,
              onChanged: (value) {
                context.read<SevkEtmeCubit>().gidecegiYer =
                    (value as GidecegiYer);
                context.read<SevkEtmeCubit>().gidecegiYerSelected();
              },
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  context.read<SevkEtmeCubit>().gidecegiYerController.clear();
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildMusteriAdiField(BuildContext context) {
    return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
      builder: (context, state) {
        if (context.read<SevkEtmeCubit>().isSevkYourself) {
          return const SizedBox();
        }
        return ValueListenableBuilder(
          valueListenable:
              Hive.box<List<dynamic>>(MusteriListCacheManager.instance.key)
                  .listenable(),
          builder:
              (BuildContext context, Box<List<dynamic>>? box, Widget? child) {
            List<Musteri>? musteriList = [];
            for (var element in (box
                    ?.get(ActiveTc.instance.activeTc)
                    ?.map((e) => Musteri.fromJson(Map<String, dynamic>.from(e)))
                    .toList() ??
                [])) {
              if (element.isregisteredToHks) {
                for (var item in element.musteriSifatIdList) {
                  if (context
                      .read<SevkEtmeCubit>()
                      .komisyoncununSevkYapabilecegiSifatlar
                      .keys
                      .contains(item)) {
                    musteriList.add(element);
                    break;
                  }
                }
              }
            }
            if (musteriList.isEmpty) {
              return ElevatedButton(
                  onPressed: () {
                    context.read<HomeCubit>().currentIndex = 2;
                    context.read<HomeCubit>().pageController.jumpToPage(2);
                  },
                  child: const Text("Müşteri Ekle"));
            }
            return DropDown2CustomerSearch(
              items: musteriList,
              controller: context.read<SevkEtmeCubit>().musteriAdiController,
              selectedValue: context.read<SevkEtmeCubit>().selectedMusteri,
              onChanged: (value) {
                context.read<SevkEtmeCubit>().selectedMusteri = value;
                context.read<SevkEtmeCubit>().musteriSelected();
              },
              onMenuStateChange: () {
                context.read<SevkEtmeCubit>().musteriAdiController.clear();
              },
            );
          },
        );
      },
    );
  }

  void blocListener(BuildContext context, SevkEtmeState state) {
    if (state is SevkEtmeLoading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
        ..loadingStyle = EasyLoadingStyle.light
        ..userInteractions = false;
      EasyLoading.show(status: 'HKS Bekleniyor...');
    } else {
      EasyLoading.dismiss();
    }
    if (state is SevkEtmeError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is SevkEtmeSuccessfulForJustIrsaliye) {
      ScaffoldMessengerHelper.instance
          .showSuccessfulSnackBar(context, "İrsaliye Kesildi");
    }
    if (state is SevkEtmeSuccessfulHasSomeError) {
      if (state.response.kayitCevapList == null) {}
      List<Widget> basarili =
          buildSuccessfulTexts(state.response.kayitCevapList!, context);

      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          context: context,
          btnCancelOnPress: () {
            context.read<SevkEtmeCubit>().clearFaturaInfo();
          },
          btnOkOnPress: () async {
            context.read<SevkEtmeCubit>().clearFaturaInfo();

            await context
                .read<SevkEtmeCubit>()
                .shareWithWhatsapp(state.response);
          },
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
                          context.read<SevkEtmeCubit>().isIrsaliyeKesSuccess
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
              ],
            ),
          )).show();

      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, "Bildirim başarısız");
    }
    if (state is SevkEtmeCompletelySuccessful) {
      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            context.read<SevkEtmeCubit>().clearFaturaInfo();
            //    Navigator.pop(context); //Named e dönüp düzeteceğim
          },
          btnOkOnPress: () async {
            context.read<SevkEtmeCubit>().clearFaturaInfo();

            //  Navigator.pop(context);
            await context
                .read<SevkEtmeCubit>()
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
                          context.read<SevkEtmeCubit>().isIrsaliyeKesSuccess
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
                  trailing: const Icon(
                    Icons.error,
                  ),
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
        context.read<SevkEtmeCubit>().getMallar.forEach((key, value) {
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

  BlocBuilder<SevkEtmeCubit, SevkEtmeState> buildTable2(BuildContext context) {
    return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
      builder: (context, state) {
        return context.watch<SevkEtmeCubit>().selectedKunyeler.ext.isNullOrEmpty
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    height: 50 +
                        (context.read<SevkEtmeCubit>().selectedKunyeler.length *
                            60),
                    child: DataTable2(
                        dataRowHeight: 60,
                        headingRowHeight: 50,
                        columnSpacing: 12,
                        horizontalMargin: 12,
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
                            label: Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.green,
                            ),
                            fixedWidth: 30,
                            size: ColumnSize.S,
                          ),
                        ],
                        rows: <DataRow>[
                          ...(context
                              .read<SevkEtmeCubit>()
                              .selectedKunyeler
                              .map(
                            (e) {
                              return DataRow(cells: <DataCell>[
                                DataCell(Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.malinAdi ?? "BOŞ",
                                      overflow: TextOverflow.visible,
                                      style: context
                                          .general.textTheme.labelSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      e.malinAdi ?? "BOŞ",
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
                                      value = value.trim();

                                      if (value.trim() != "") {
                                        if (!context
                                            .read<SevkEtmeCubit>()
                                            .isNumeric(value.trim())) {
                                          return "rakam ve . , kullanabilirsiniz";
                                        }
                                      }
                                      if (!(double.parse(
                                              (value.isEmpty || value == "")
                                                  ? e.kalanMiktar!
                                                  : value) <=
                                          double.parse(e.kalanMiktar!))) {
                                        return "büyük değer";
                                      }

                                      if (!(value == null)) {
                                        if (value == "") {
                                          value = "0";
                                        }

                                        if (double.parse(value) >= 0) {
                                          e.gonderilmekIstenenMiktar = value;
                                        }
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: context.padding.low,
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              context.sized.normalValue * 3),
                                      hintText:
                                          "${e.kalanMiktar ?? "boş"} ${e.malinMiktarBirimAd ?? "boş"}",
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
                                      .read<SevkEtmeCubit>()
                                      .removeFromSelectedKunyeList(e);
                                })
                              ]);
                            },
                          ).toList()),
                        ]),
                  ),
                  buildAracPlakaField(context), buildFaturaColumn(context),
                  buildDriverMain(context),
                  context.read<SevkEtmeCubit>().isSevkYourself
                      ? buildSevkYapButton(context)
                      : buildBildirimYapButton(context),
                  // Expanded(child: SizedBox())
                ],
              );
      },
    );
  }

  Padding buildDriverMain(BuildContext context) {
    return Padding(
      padding: context.padding.low,
      child: !context.read<SevkEtmeCubit>().isIrsaliye
          ? const SizedBox()
          : Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        !context.read<SevkEtmeCubit>().isSurucuManual
                            ? buildDriverDropDown(context)
                            : const SizedBox(),
                        buildeEnterDriverInfos(context),
                      ],
                    )
                  ],
                ),
                buildDriverForm(context),
              ],
            ),
    );
  }

  Widget buildDriverDropDown(BuildContext context) {
    return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
      builder: (context, state) {
        return DropDown2DriverSearch(
          controller:
              context.read<SevkEtmeCubit>().driverAdiControllerForDropDown,
          onChanged: (value) {
            context.read<SevkEtmeCubit>().selectedDriver = value;
            context.read<SevkEtmeCubit>().emitInitialState();
          },
          selectedValue: context.read<SevkEtmeCubit>().selectedDriver,
          onMenuStateChange: () {
            context
                .read<SevkEtmeCubit>()
                .driverAdiControllerForDropDown
                .clear();
          },
        );
      },
    );
  }

  Widget buildDriverForm(BuildContext context) {
    return !context.read<SevkEtmeCubit>().isSurucuManual
        ? const SizedBox()
        : Form(
            key: context.read<SevkEtmeCubit>().driverFormKey,
            child: Column(
              children: [
                Padding(
                  padding: context.padding.normal,
                  child: TextFormField(
                    controller:
                        context.read<SevkEtmeCubit>().driverIdController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Tc giriniz';
                      }
                      if (!context.read<SevkEtmeCubit>().isNumeric(value)) {
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
                        .read<SevkEtmeCubit>()
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
                    controller:
                        context.read<SevkEtmeCubit>().driverNameController,
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
                        .read<SevkEtmeCubit>()
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
        value: context.read<SevkEtmeCubit>().isSurucuManual,
        onChanged: (value) {
          context.read<SevkEtmeCubit>().isSurucuManual = value!;
          context.read<SevkEtmeCubit>().emitInitialState();
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
            return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
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
      activeColor: Colors.green,
      value: context.read<SevkEtmeCubit>().isIrsaliye,
      onChanged: (value) {
        context.read<SevkEtmeCubit>().isIrsaliye = value!;
        context.read<SevkEtmeCubit>().emitInitialState();
      },
      title: const Text(
        "İrsaliye Kes",
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding buildSevkYapButton(BuildContext context) {
    return Padding(
      padding: context.padding.verticalNormal,
      child: FloatingActionButton.extended(
          heroTag: "sevkyapbutton",
          backgroundColor: Colors.green,
          onPressed: () async {
            context.read<SevkEtmeCubit>().activateAutoValidateModeForPlaka();

            if (context.read<SevkEtmeCubit>().isIrsaliye) {
              if (context.read<SevkEtmeCubit>().isSurucuManual) {
                context
                    .read<SevkEtmeCubit>()
                    .activateAutoValidateModeForDriver();

                if (context
                    .read<SevkEtmeCubit>()
                    .driverFormKey
                    .currentState!
                    .validate()) {
                  context.read<SevkEtmeCubit>().selectedDriver = DriverModel(
                      tc: context
                          .read<SevkEtmeCubit>()
                          .driverIdController
                          .text
                          .trim(),
                      userName: context
                          .read<SevkEtmeCubit>()
                          .driverNameController
                          .text
                          .trim()
                          .toUpperCaseTr());
                  if (context
                      .read<SevkEtmeCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SevkEtmeCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context.read<SevkEtmeCubit>().sevkYap(context);
                  }
                }
              } else {
                if (context.read<SevkEtmeCubit>().selectedDriver == null) {
                  context.read<SevkEtmeCubit>().emitError(
                      "Sürücü Seçiniz ve ya manuel olarak ekleyiniz");
                } else {
                  if (context
                      .read<SevkEtmeCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SevkEtmeCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context.read<SevkEtmeCubit>().sevkYap(context);
                  }
                }
                //check selected driver
              }
            } else {
              if (context
                  .read<SevkEtmeCubit>()
                  .plakaFormKey
                  .currentState!
                  .validate()) {
                context.read<SevkEtmeCubit>().disableAutoValidateModeForPlaka();
                await context.read<SevkEtmeCubit>().sevkYap(context);
              }
            }
          },
          label: const Text("Sevk Et")),
    );
  }

  Padding buildBildirimYapButton(BuildContext context) {
    return Padding(
      padding: context.padding.verticalNormal,
      child: FloatingActionButton.extended(
          heroTag: "sevk bildirim",
          backgroundColor: Colors.green,
          onPressed: () async {
            context.read<SevkEtmeCubit>().activateAutoValidateModeForPlaka();

            if (context.read<SevkEtmeCubit>().isIrsaliye) {
              if (context.read<SevkEtmeCubit>().isSurucuManual) {
                context
                    .read<SevkEtmeCubit>()
                    .activateAutoValidateModeForDriver();

                if (context
                    .read<SevkEtmeCubit>()
                    .driverFormKey
                    .currentState!
                    .validate()) {
                  context.read<SevkEtmeCubit>().selectedDriver = DriverModel(
                      tc: context
                          .read<SevkEtmeCubit>()
                          .driverIdController
                          .text
                          .trim(),
                      userName: context
                          .read<SevkEtmeCubit>()
                          .driverNameController
                          .text
                          .trim()
                          .toUpperCaseTr());
                  if (context
                      .read<SevkEtmeCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SevkEtmeCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context.read<SevkEtmeCubit>().bildirimYap(context);
                  }
                }
              } else {
                if (context.read<SevkEtmeCubit>().selectedDriver == null) {
                  context.read<SevkEtmeCubit>().emitError(
                      "Sürücü Seçiniz ve ya manuel olarak ekleyiniz");
                } else {
                  if (context
                      .read<SevkEtmeCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SevkEtmeCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context.read<SevkEtmeCubit>().bildirimYap(context);
                  }
                }
                //check selected driver
              }
            } else {
              if (context
                  .read<SevkEtmeCubit>()
                  .plakaFormKey
                  .currentState!
                  .validate()) {
                context.read<SevkEtmeCubit>().disableAutoValidateModeForPlaka();
                await context.read<SevkEtmeCubit>().bildirimYap(context);
              }
            }
          },
          label: const Text("Bildirim Yap")),
    );
  }

  Widget buildTableView2(BuildContext context) {
    return context.watch<SevkEtmeCubit>().selectedKunyeler.ext.isNullOrEmpty
        ? Container()
        : DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Ürün Adı',
                  style: TextStyle(fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataColumn(
                label: Text(
                  'Miktarı',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Fiyatı',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: <DataRow>[
              ...(context.read<SevkEtmeCubit>().selectedKunyeler.map(
                (e) {
                  Icons.delete;
                  return DataRow(cells: <DataCell>[
                    DataCell(Text(e.malinAdi ?? "boş")),
                    // DataCell(Text((e.kalanMiktar ?? "boş") +  " " + (e.malinMiktarBirimAd ?? "boş"))),
                    DataCell(Padding(
                      padding: context.padding.verticalLow,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        validator: (value) {
                          value = value?.trim();
                          if (!(double.parse((value == null ||
                                      value.isEmpty ||
                                      value == "")
                                  ? e.kalanMiktar!
                                  : value) <=
                              double.parse(e.kalanMiktar!))) {
                            return "kalan miktar hata";
                          }

                          if (!(value == null)) {
                            if (value == "") {
                              value = "0";
                            }
                            if (double.parse(value) >= 0) {
                              e.gonderilmekIstenenMiktar = value;
                            }
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: context.padding.low,
                          constraints: BoxConstraints(
                              maxHeight: context.sized.normalValue * 3),
                          hintText:
                              "${e.kalanMiktar ?? "boş"} ${e.malinMiktarBirimAd ?? "boş"}",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    )),
                    DataCell(Text("${e.malinSatisFiyati ?? "boş"}₺"),
                        showEditIcon: true, onTap: () {
                      context
                          .read<SevkEtmeCubit>()
                          .removeFromSelectedKunyeList(e);
                    }),
                  ]);
                },
              ).toList()),
            ],
          );
  }

  Widget buildKunyeSorgulama(BuildContext context) {
    return BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
      builder: (context, state) {
        if (context.read<SevkEtmeCubit>().isSevkYourself) {
          return buildKunyeSorgulaButton(context);
        }
        return (context.read<SevkEtmeCubit>().selectedMusteri != null &&
                context.read<SevkEtmeCubit>().gidecegiYer != null)
            ? buildKunyeSorgulaButton(context)
            : const SizedBox();
      },
    );
  }

  Padding buildKunyeSorgulaButton(BuildContext context) {
    return Padding(
      padding: context.padding.verticalNormal,
      child: FloatingActionButton.extended(
          heroTag: "Künye Sorgula",
          backgroundColor: Colors.green,
          onPressed: () async {
            context
                .read<SevkEtmeCubit>()
                .fetchKunyeTransActionsWithNewDate(
                    context.read<SevkEtmeCubit>().startDay,
                    context.read<SevkEtmeCubit>().endDay)
                .then((value) {
              context.read<SevkEtmeCubit>().emitInitialState();

              DropDownState(
                DropDown(
                  submitButtonText: "Seçimi tamala",
                  submitButtonColor: const Color.fromRGBO(70, 76, 222, 1),
                  searchHintText: "Ürün arat",
                  bottomSheetTitle: "Referans Künyeler",
                  searchBackgroundColor: Colors.black12,
                  dataList: context
                      .read<SevkEtmeCubit>()
                      .allReferansKunyeler
                      .map((e) => SelectedListItem(
                          context.read<SevkEtmeCubit>().kunyeSelectedOrNot(e),
                          referansKunye: e))
                      .toList(),
                  selectedItems: (List<ReferansKunye> selectedList) {
                    context.read<SevkEtmeCubit>().selectedKunyeler =
                        selectedList;
                    context.read<SevkEtmeCubit>().kunyelerSelected();

                    context
                        .read<SevkEtmeCubit>()
                        .searchKunyeTextEditingController
                        .clear();
                  },
                  enableMultipleSelection: true,
                  searchController: context
                      .read<SevkEtmeCubit>()
                      .searchKunyeTextEditingController,
                ),
              ).showModal(context);
            });
          },
          label: const Text("Künye Sorgula")),
    );
  }

  //TODO: total tl için converter yaz . , virgül convertı da yaz
  List<TableRow> buildTableContents(BuildContext context) {
    return context
        .read<SevkEtmeCubit>()
        .selectedKunyeler
        .map(
          (e) => TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(e.malinAdi ?? "boş")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                      "${e.kalanMiktar ?? "boş"} ${e.malinMiktarBirimAd ?? "boş"}")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("${e.malinSatisFiyati ?? "boş"}₺")),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Center(
            //       child: Text((double.parse(e.urunFiyati!) *
            //                   double.parse(e.urunMiktari))
            //               .toString() +
            //           "₺")),
            // ),
          ]),
        )
        .toList();
  }

  TableRow buildTableHeader() {
    return const TableRow(children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text("Adı")),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text("Miktarı")),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text("Fiyatı")),
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Center(child: Text("Toplam")),
      // ),
    ]);
  }

  Padding buildAracPlakaField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SevkEtmeCubit, SevkEtmeState>(
        builder: (context, state) {
          return Form(
            key: context.read<SevkEtmeCubit>().plakaFormKey,
            child: TextFormField(
              autovalidateMode:
                  context.read<SevkEtmeCubit>().isAutoValidateModeForPlaka,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'lütfen plaka bilgisi giriniz';
                }
                return null;
              }),
              controller: context.read<SevkEtmeCubit>().plakaController,
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

  Widget buildTable(BuildContext context) =>
      context.watch<SevkEtmeCubit>().selectedKunyeler.ext.isNullOrEmpty
          ? Container()
          : Padding(
              padding: context.padding.horizontalLow,
              child: Table(
                border:
                    TableBorder.all(borderRadius: BorderRadius.circular(10)),
                children: [buildTableHeader(), ...buildTableContents(context)],
              ),
            );
}
