import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/komisyoncu_bildirim_page/viewmodel/cubit/komisyoncu_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/satis_page/view/satis_page.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/sevk_etme_for_komisyoncu_page/view/sevk_etme_for_komisyoncu_page.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/sevk_etme_for_komisyoncu_page/viewmodel/cubit/sevk_etme_for_komisyoncu_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/ureticiden_sevk_alim/view/ureticiden_sevk_alim_page.dart';
import 'package:hal_app/project/utils/widgets/custom_dropdown2.dart';
import 'package:kartal/kartal.dart';

class KomisyoncuPage extends StatelessWidget {
  const KomisyoncuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildBildirimTipiDropDown(context),
        Expanded(
          child: BlocBuilder<KomisyoncuCubit, KomisyoncuState>(
            builder: (context, state) {
              if (state is KomisyoncuSatis) {
                //    context.read<SatinAlimCubit>().customInit();
                return const SatisPage();
              } else if (state is KomisyoncuSevkAlim) {
                //  context.read<SevkEtmeCubit>().customInit();

                return const UreticiSevkAlimBildirimPage();
              } else if (state is KomisyoncuSevkEtme) {
                //  context.read<SevkEtmeCubit>().customInit();

                return const SevkEtmeForKomisyoncuPage();
              } else {
                return const SatisPage();
              }
              return const Center();
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
            .read<KomisyoncuCubit>()
            .komisyoncuBildirimTypes
            .values
            .toList(),
        icon: const Icon(Icons.arrow_drop_down_sharp, size: 24),
        value: context.watch<KomisyoncuCubit>().bildirimType,
        onChanged: (value) {
          //  context.read<SatinAlimCubit>().clearAllPageInfo();
          context.read<SevkEtmeForKomisyoncuCubit>().clearAllPageInfo();
          context.read<KomisyoncuCubit>().bildirimType = value!;

          context.read<KomisyoncuCubit>().bildirimTypeSelected();
        },
      ),
    );
  }
}
