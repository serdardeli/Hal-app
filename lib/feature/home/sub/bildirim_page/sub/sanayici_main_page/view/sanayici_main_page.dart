// dropdown done

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/sanayici_main_page/viewmodel/cubit/sanayici_main_cubit.dart';
import 'package:hal_app/project/utils/widgets/custom_dropdown2.dart';
import 'package:kartal/kartal.dart';

import '../../satin_alim_sanayici_page/view/sanayici_satis_page.dart';
import '../../satis_page/view/satis_page.dart';
import '../../sevk_etme_for_sanayici/view/sevk_etme_for_sanayici_page.dart';

class SanayiciMainPage extends StatelessWidget {
  const SanayiciMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildBildirimTipiDropDown(context),
        Expanded(
          child: BlocBuilder<SanayiciMainCubit, SanayiciMainState>(
            builder: (context, state) {
              if (state is SanayiciSatis) {
                //    context.read<SatinAlimCubit>().customInit();
                return const SatisPage();
              } else if (state is SanayiciSatinAlim) {
                //  context.read<SevkEtmeCubit>().customInit();
                return const SanayiciSatinAlimPage();
              } else if (state is SanayiciSevkEtme) {
                //  context.read<SevkEtmeCubit>().customInit();

                return const SevkEtmeForSanayiciPage();
              } else {
                return const SatisPage();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildBildirimTipiDropDown(BuildContext context) {
    return Padding(
      padding: context.padding.verticalLow,
      child: CustomDropdownButton2(
        buttonWidth: context.general.mediaSize.width * .4,
        hint: 'Bildirim Tipi seç',
        dropdownItems: context
            .read<SanayiciMainCubit>()
            .komisyoncuBildirimTypes
            .values
            .toList(),
        icon: const Icon(Icons.arrow_drop_down_sharp, size: 24),
        value: context.watch<SanayiciMainCubit>().bildirimType,
        onChanged: (value) {
          //  context.read<SatinAlimCubit>().clearAllPageInfo();
          //     context.read<SevkEtmeForKomisyoncuCubit>().clearAllPageInfo();
          context.read<SanayiciMainCubit>().bildirimType = value!;

          context.read<SanayiciMainCubit>().bildirimTypeSelected();
        },
      ),
    );
  }
}
