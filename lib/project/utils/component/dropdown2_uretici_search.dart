import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/feature/helper/active_tc.dart';
import 'package:hal_app/project/cache/uretici_list_cache_manager.dart';
import 'package:hal_app/project/model/uretici_model/uretici_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

class DropDown2UreticiSearch extends StatelessWidget {
  const DropDown2UreticiSearch({
    super.key,
    this.controller,
    this.dropdownWidth,
    this.buttonWidth,
    this.selectedValue,
    this.onChanged,
    this.onMenuStateChange,
    this.hint,
  });
  final TextEditingController? controller;
  final double? dropdownWidth;
  final double? buttonWidth;
  final Uretici? selectedValue;
  final Function(Uretici)? onChanged;
  final Function()? onMenuStateChange;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<List<dynamic>>(UreticiListCacheManager.instance.key)
                .listenable(),
        builder:
            (BuildContext context, Box<List<dynamic>>? box, Widget? child) {
          List<Uretici>? ureticiList = box
                  ?.get(ActiveTc.instance.activeTc)
                  ?.map((e) => Uretici.fromJson(Map<String, dynamic>.from(e)))
                  .toList() ??
              [];
          return DropdownButtonHideUnderline(
            child: DropdownButton2<Uretici>(
              isExpanded: true,
              dropdownSearchData: controller == null
                  ? null
                  : DropdownSearchData(
                      searchInnerWidgetHeight: 30,
                      searchInnerWidget: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          controller: controller,
                          autofocus: true,
                          decoration: InputDecoration(
                            // isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: hint,
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchController: controller,
                      searchMatchFn: (item, searchValue) {
                        return ((item.value as Uretici)
                            .ureticiAdiSoyadi
                            .toString()
                            .toLowerCaseTr()
                            .contains(searchValue.toLowerCaseTr()));
                      },
                    ),
              dropdownStyleData: DropDown2Style.dropdownStyleData(context,
                  width: dropdownWidth ?? context.general.mediaSize.width * .5),
              buttonStyleData:
                  DropDown2Style.buttonStyleData(context, width: buttonWidth),
              hint: Text(hint ?? "Üretici Seçiniz",
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).hintColor)),
              items: ureticiList
                  .map((uretici) => DropdownMenuItem<Uretici>(
                        value: uretici,
                        child: Text(
                            uretici == null
                                ? "Toplama Mal"
                                : (uretici.ureticiAdiSoyadi),
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (value) {
                onChanged?.call(value!);
                // context.read<SatinAlimCubit>().malinAdiSelected(value as String);
              },
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  onMenuStateChange?.call();
                  // context.read<SatinAlimCubit>().malinAdiController.clear();
                }
              },
            ),
          );
        });
  }
}
