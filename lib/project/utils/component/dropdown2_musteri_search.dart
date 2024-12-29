import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/project/model/musteri_model/musteri_model.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

class DropDown2CustomerSearch extends StatelessWidget {
  const DropDown2CustomerSearch({
    super.key,
    this.controller,
    this.dropdownWidth,
    this.buttonWidth,
    this.selectedValue,
    this.onChanged,
    this.onMenuStateChange,
    this.hint,
    required this.items,
  });
  final TextEditingController? controller;
  final double? dropdownWidth;
  final double? buttonWidth;
  final Musteri? selectedValue;
  final List<Musteri> items;
  final Function(Musteri)? onChanged;
  final Function()? onMenuStateChange;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Musteri>(
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
                  return ((item.value as Musteri)
                      .musteriAdiSoyadi
                      .toString()
                      .toLowerCaseTr()
                      .contains(searchValue.toLowerCaseTr()));
                },
              ),
        dropdownStyleData: DropDown2Style.dropdownStyleData(context,
            width: dropdownWidth ?? context.general.mediaSize.width * .5),
        buttonStyleData: DropDown2Style.buttonStyleData(context,
            width: buttonWidth ?? context.general.mediaSize.width * .4),
        hint: Text(hint ?? "Müşteri Seçiniz",
            style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
        items: items
            .map((musteri) => DropdownMenuItem<Musteri>(
                  value: musteri,
                  child: Text(
                      musteri == null
                          ? "Toplama Mal"
                          : (musteri.musteriAdiSoyadi),
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          onChanged?.call(value!);
        },
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            onMenuStateChange?.call();
          }
        },
      ),
    );
  }
}
