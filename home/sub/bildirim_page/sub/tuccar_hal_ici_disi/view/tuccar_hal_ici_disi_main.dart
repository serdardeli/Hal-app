// dropdown done

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/satis_page/viewmodel/cubit/satis_cubit.dart';
import 'package:hal_app/project/utils/widgets/custom_dropdown2.dart';
import '../../sat%C4%B1n_al%C4%B1m_page/viewmodel/cubit/satin_alim_cubit.dart';
import '../../satis_page/view/satis_page.dart';
import '../../sevk_etme_page/viewmodel/cubit/sevk_etme_cubit.dart';
import '../viewmodel/cubit/tuccar_hal_ici_disi_main_cubit.dart';
import 'package:kartal/kartal.dart';

import '../../satın_alım_page/view/satın_alım_page.dart';
import '../../sevk_etme_page/view/sevk_etme_page.dart';

class TuccarHalIciDisiMain extends StatelessWidget {
  const TuccarHalIciDisiMain({Key? key}) : super(key: key);
  buildFirstRowForSatinAlim(BuildContext context) {
    if (context
            .read<TuccarHalIciDisiMainCubit>()
            .kullanicininDesteklenenSifatlari
            .length ==
        1) {
      return Row(
        children: [
          const Spacer(flex: 4),
          Expanded(flex: 6, child: buildBildirimTipiDropDown(context)),
          const Spacer(flex: 4),
          // Expanded(flex: 4, child: clearBildirimPageIcon(context))
        ],
      );
    } else {
      return Row(
        children: [
          const Spacer(flex: 1),
          Expanded(flex: 6, child: buildBildirimTipiDropDown(context)),
          const Spacer(flex: 1),
          Expanded(flex: 6, child: buildUserSifatDropDown(context)),
          const Spacer(flex: 1),
        ],
      );
    }
  }

  buildFirstRowForSevkEtme(BuildContext context) {
    if (context
            .read<TuccarHalIciDisiMainCubit>()
            .kullanicininDesteklenenSifatlari
            .length ==
        1) {
      return Row(
        children: [
          const Spacer(flex: 4),
          Expanded(flex: 6, child: buildBildirimTipiDropDown(context)),
          const Spacer(flex: 4),
          // Expanded(flex: 4, child: clearBildirimPageIcon(context))
        ],
      );
    } else {
      return Row(
        children: [
          const Spacer(flex: 1),
          Expanded(flex: 6, child: buildBildirimTipiDropDown(context)),
          const Spacer(flex: 1),
          Expanded(flex: 6, child: buildUserSifatDropDown(context)),
          const Spacer(flex: 1),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: context.general.mediaSize.height * .01),
          Expanded(
            child: BlocConsumer<TuccarHalIciDisiMainCubit,
                TuccarHalIciDisiMainState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is TuccarHalIciDisiMainSatinAlim) {
                  context.read<SatinAlimCubit>().customInit();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: context.padding.verticalLow,
                          child: buildFirstRowForSatinAlim(context),
                        ),
                        const SatinAlinPage(),
                      ],
                    ),
                  );
                } else if (state is TuccarHalIciDisiMainSevkEtme) {
                  context.read<SevkEtmeCubit>().customInit();

                  return Column(
                    children: [
                      Padding(
                        padding: context.padding.verticalLow,
                        child: buildFirstRowForSevkEtme(context),
                      ),
                      const Expanded(child: SevkEtmePage())
                    ],
                  );
                } else if (state is TuccarHalIciDisiMainSatis) {
                  //    context.read<SevkEtmeCubit>().customInit();
                  context.read<SatisCubit>().customInit();

                  return Column(
                    children: [
                      Padding(
                        padding: context.padding.verticalLow,
                        child: buildFirstRowForSevkEtme(context),
                      ),
                      const Expanded(child: SatisPage())
                    ],
                  );
                } else {
                  return const Center(child: Text("BİLDİRİM TİPİ BULUNAMADI"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBildirimTipiDropDown(BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return SizedBox(
          width: 100,
          child: CustomDropdownButton2(
            hint: 'Bildirim Tipi seç',
            dropdownItems: context
                .read<TuccarHalIciDisiMainCubit>()
                .tuccarBildirimTypes
                .values
                .toList(),
            icon: const Icon(Icons.arrow_drop_down_sharp, size: 24),
            value: context.watch<TuccarHalIciDisiMainCubit>().bildirimType,
            onChanged: (value) {
              context.read<SatinAlimCubit>().clearAllPageInfo();

              context.read<TuccarHalIciDisiMainCubit>().bildirimType = value!;

              context.read<TuccarHalIciDisiMainCubit>().bildirimTypeSelected();
            },
          ),
        );
      },
    );
  }

  Widget buildUserSifatDropDown(BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return SizedBox(
          width: 100,
          child: CustomDropdownButton2(
            hint: 'Sifat Seç',
            dropdownItems: context
                .read<TuccarHalIciDisiMainCubit>()
                .kullanicininDesteklenenSifatlari
                .values
                .toList(),
            icon: const Icon(Icons.arrow_drop_down_sharp, size: 24),
            value: context.watch<TuccarHalIciDisiMainCubit>().selectedSifatType,
            onChanged: (value) {
              context.read<TuccarHalIciDisiMainCubit>().selectedSifatType =
                  value!;
              context.read<TuccarHalIciDisiMainCubit>().sifatTypeSelected();
            },
          ),
        );
      },
    );
  }
}
