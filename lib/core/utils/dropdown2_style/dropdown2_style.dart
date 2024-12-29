import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class DropDown2Style {
  static DropdownStyleData dropdownStyleData(BuildContext context,
      {double? width}) {
    return DropdownStyleData(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black26),
      ),
      padding: context.padding.low,
      width: width ?? context.general.mediaSize.width * .5,
    );
  }

  static ButtonStyleData buttonStyleData(BuildContext context,
      {double? width, double? height, EdgeInsetsGeometry? padding}) {
    return ButtonStyleData(
      padding: padding ?? context.padding.low,
      height: height ?? 50,
      width: width ?? 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black26),
      ),
    );
  }
}
