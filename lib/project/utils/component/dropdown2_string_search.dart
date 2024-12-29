import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

class DropDown2StringSearch extends StatelessWidget {
  const DropDown2StringSearch({
    super.key,
    this.controller,
    this.dropdownWidth,
    this.buttonWidth,
    required this.items,
    this.selectedValue,
    this.onChanged,
    this.onMenuStateChange,
    this.hint,
  });
  final TextEditingController? controller;
  final double? dropdownWidth;
  final double? buttonWidth;
  final List<String> items;
  final String? selectedValue;
  final Function(String)? onChanged;
  final Function()? onMenuStateChange;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
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
                  return (item.value
                      .toString()
                      .toLowerCaseTr()
                      .contains(searchValue.toLowerCaseTr()));
                },
              ),
        dropdownStyleData: DropDown2Style.dropdownStyleData(context,
            width: dropdownWidth ?? context.general.mediaSize.width * .5),
        buttonStyleData:
            DropDown2Style.buttonStyleData(context, width: buttonWidth),
        hint: Text(hint ?? 'Ürün Seç',
            style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                        fontSize: 14, overflow: TextOverflow.ellipsis),
                  ),
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
  }
}
