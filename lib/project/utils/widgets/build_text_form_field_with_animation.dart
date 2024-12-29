import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

Widget buildTextFormFieldWithAnimation(BuildContext context,
    {required bool isSearchOpen,
    required TextEditingController controller,
    required Function onChanged,
    required FocusNode focusNode}) {
  return AnimatedSize(
    curve: Curves.decelerate,
    duration: context.duration.durationNormal,
    child: SizedBox(
      height: isSearchOpen ? context.general.mediaSize.height * 0.07 : 0,
      child: Padding(
        padding: context.padding.low,
        child: AnimatedOpacity(
          duration: context.duration.durationNormal,
          opacity: isSearchOpen ? 1 : 0,
          child: _buildTextFormField(
              isSearchOpen, context, controller, onChanged, focusNode),
        ),
      ),
    ),
  );
}

TextFormField _buildTextFormField(bool isSearchOpen, BuildContext context,
    TextEditingController controller, Function onChanged, FocusNode focusNode) {
  return TextFormField(
    // cursorHeight: isSearchOpen ? context.general.mediaSize.height * 0.028 : 0,
    controller: controller,

    cursorColor: Colors.grey[850],
    onChanged: (E) {

      onChanged();
    },
    decoration:
        InputDecoration(contentPadding: context.padding.horizontalLow * 2.5),
    focusNode: focusNode,
    autofocus: isSearchOpen ? true : false,
    //  decoration: const InputDecoration(border: OutlineInputBorder()),
  );
}
