import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

Widget buildAnimatedBoxForFilter(
  BuildContext context, {
  required bool isSearchOpen,
  required TextEditingController minController,
  required TextEditingController maxController,
  required TextEditingController plakaController,
  required VoidCallback onChanged,
}) {
  return AnimatedSize(
    curve: Curves.decelerate,
    duration: context.duration.durationNormal,
    child: SizedBox(
      height: isSearchOpen ? context.general.mediaSize.height * 0.25 : 0,
      child: Padding(
        padding: context.padding.low,
        child: AnimatedOpacity(
            duration: context.duration.durationNormal,
            opacity: isSearchOpen ? 1 : 0,
            child: Padding(
              padding: context.padding.verticalLow,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFormFieldMin(
                            isSearchOpen, context, minController),
                      ),
                      Expanded(
                        child: _buildTextFormFieldMax(
                            isSearchOpen, context, maxController),
                      ),
                    ],
                  ),
                  Padding(
                    padding: context.padding.verticalLow,
                    child: _buildTextFormFieldPlaka(
                        isSearchOpen, context, plakaController),
                  ),
                  ElevatedButton(onPressed: onChanged, child: const Text("Uygula"))
                ],
              ),
            )),
      ),
    ),
  );
}

Padding _buildTextFormFieldMin(
    bool isSearchOpen, BuildContext context, TextEditingController controller) {
  return Padding(
    padding: context.padding.horizontalLow,
    child: TextFormField(
      // cursorHeight: isSearchOpen ? context.general.mediaSize.height * 0.028 : 0,
      controller: controller,

      cursorColor: Colors.grey[850],

      decoration: InputDecoration(
          contentPadding: context.padding.horizontalLow * 2.5,
          border: const OutlineInputBorder(),
          hintText: "Min"),
      autofocus: isSearchOpen ? true : false, keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.always,

      maxLines: 1,
      validator: (value) {
        value = value?.trim();



        if (!(value == null)) {
          if (value == "") {
            value = "0";
          }
        }
        if (!isNumeric(value)) {
          return "rakam ve . , kullanabilirsiniz";
        }

        return null;
      },
      //  decoration: const InputDecoration(border: OutlineInputBorder()),
    ),
  );
}

Padding _buildTextFormFieldPlaka(
    bool isSearchOpen, BuildContext context, TextEditingController controller) {
  return Padding(
    padding: context.padding.horizontalLow,
    child: TextFormField(
      // cursorHeight: isSearchOpen ? context.general.mediaSize.height * 0.028 : 0,
      controller: controller,

      cursorColor: Colors.grey[850],

      decoration: InputDecoration(
          contentPadding: context.padding.horizontalLow * 2.5,
          border: const OutlineInputBorder(),
          hintText: "plaka"),
      autofocus: isSearchOpen ? true : false,
      autovalidateMode: AutovalidateMode.always,

      maxLines: 1,
      validator: (value) {
        value = value?.trim();



        return null;
      },
      //  decoration: const InputDecoration(border: OutlineInputBorder()),
    ),
  );
}

bool isNumeric(String? s) {
  if (s == null || s.trim() == "") {
    return false;
  }
  return double.tryParse(s.trim()) != null;
}

Padding _buildTextFormFieldMax(
    bool isSearchOpen, BuildContext context, TextEditingController controller) {
  return Padding(
    padding: context.padding.horizontalLow,
    child: TextFormField(
      // cursorHeight: isSearchOpen ? context.general.mediaSize.height * 0.028 : 0,
      controller: controller,

      cursorColor: Colors.grey[850],

      decoration: InputDecoration(
          contentPadding: context.padding.horizontalLow * 2.5,
          border: const OutlineInputBorder(),
          hintText: "Max"),
      autofocus: isSearchOpen ? true : false, keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.always,

      validator: (value) {
        value = value?.trim();



        if (!(value == null)) {
          if (value == "") {
            value = "0";
          }
        }
        if (!isNumeric(value)) {
          return "rakam ve . , kullanabilirsiniz";
        }

        return null;
      },
      //  decoration: const InputDecoration(border: OutlineInputBorder()),
    ),
  );
}
