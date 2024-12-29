import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/sevk_etme_for_komisyoncu_page/viewmodel/cubit/sevk_etme_for_komisyoncu_cubit.dart';
import 'package:turkish/turkish.dart';
import '../../model/referans_kunye/referans_kunye_model.dart';
import 'package:intl/intl.dart';
import 'package:kartal/kartal.dart';

import 'build_animated_box_for_filter.dart';
import 'build_text_form_field_with_animation.dart';

class DropDown {
  /// This gives the button text or it sets default text as 'click me'.
  final String? buttonText;

  /// This gives the bottom sheet title.
  final String? bottomSheetTitle;

  /// This will give the submit button text.
  final String? submitButtonText;

  /// This will give the submit button background color.
  final Color? submitButtonColor;

  /// This will give the hint to the search text filed.
  final String? searchHintText;

  /// This will give the background color to the search text filed.
  final Color? searchBackgroundColor;

  /// This will give the default search controller to the search text field.
  final TextEditingController searchController;

  /// This will give the list of data.
  final List<SelectedListItem> dataList;

  /// This will give the call back to the selected items (multiple) from list.
  final Function(List<ReferansKunye>)? selectedItems;

  /// This will give the call back to the selected item (single) from list.
  final Function(String)? selectedItem;

  /// This will give selection choise for single or multiple for list.
  final bool enableMultipleSelection;

  DropDown({
    Key? key,
    this.buttonText,
    this.bottomSheetTitle,
    this.submitButtonText,
    this.submitButtonColor,
    this.searchHintText,
    this.searchBackgroundColor,
    required this.searchController,
    required this.dataList,
    this.selectedItems,
    this.selectedItem,
    required this.enableMultipleSelection,
  });
}

class DropDownState {
  DropDown dropDown;
  DropDownState(this.dropDown);

  /// This gives the bottom sheet widget.
  void showModal(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return MainBody(
              dropDown: dropDown,
            );
          },
        );
      },
    );
  }
}

/// This is Model class. Using this model class, you can add the list of data with title and its selection.
class SelectedListItem {
  bool isSelected;
  ReferansKunye referansKunye;
  // String name;
  String? value;

  SelectedListItem(this.isSelected, {this.value, required this.referansKunye});
}

/// This is main class to display the bottom sheet body.
class MainBody extends StatefulWidget {
  DropDown dropDown;

  MainBody({required this.dropDown, Key? key}) : super(key: key);

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  /// This list will set when the list of data is not available.
  List<SelectedListItem> mainList = [];
  int totalSelectedCount = 0; //max 100
  late TextEditingController minController;
  late TextEditingController plakaController;

  late TextEditingController maxController;

  late GlobalKey<FormState> formKey;
  bool isFilterOpen = false;

  DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    minController = TextEditingController();
    maxController = TextEditingController();
    plakaController = TextEditingController();

    filterMainList();
  }

  filterMainList() {
    List<SelectedListItem> newList = [];
    if (context.read<SevkEtmeForKomisyoncuCubit>().selectedMusteri != null &&
        context
            .read<SevkEtmeForKomisyoncuCubit>()
            .sadeceSelectedUreticiyeAitKunyeleriSorgula) {


      for (var element in widget.dropDown.dataList) {
        if (element.referansKunye.ureticiTcKimlikVergiNo ==
                context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .selectedMusteri!
                    .musteriTc &&
            element.referansKunye.bildirimTuru == "196") {
          newList.add(element);
        }
      }



      mainList = newList;
    } else {


      mainList = widget.dropDown.dataList;
    }
  }

  String parseDate(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');

    return displayFormater.format(dateFormat.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.13,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: [
                  buildAnimatedBoxForFilter(
                    context,
                    maxController: maxController,
                    minController: minController,
                    plakaController: plakaController,
                    isSearchOpen: isFilterOpen,
                    onChanged: () {
                      filterMainList();
                      List<SelectedListItem> newList = [];
                      for (var element in mainList) {
                        if ((double.parse(
                                    element.referansKunye.kalanMiktar ?? "0") >=
                                double.parse(minController.text.trim() == ""
                                    ? "0"
                                    : minController.text.trim()) &&
                            double.parse(
                                    element.referansKunye.kalanMiktar ?? "0") <=
                                double.parse(maxController.text.trim() == ""
                                    ? "999999999999"
                                    : maxController.text.trim()))) {
                          if (plakaController.text.trim().toLowerCaseTr() !=
                              "") {
                            if ((element.referansKunye.aracPlakaNo ?? "")
                                .toLowerCaseTr()
                                .contains(plakaController.text
                                    .trim()
                                    .toLowerCaseTr())) {
                              newList.add(element);
                            }
                          } else {
                            newList.add(element);
                          }
                        }
                      }
                      isFilterOpen = false;
                      mainList = newList;
                      FocusManager.instance.primaryFocus?.unfocus();

                      setState(() {});
                      //  context.read<SavedNotificationsCubit>().emitInitial();*/
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Bottom sheet title text
                  TextButton(
                      onPressed: () {
                        isFilterOpen = !isFilterOpen;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Text(
                            "Filtreler",
                            style: context.general.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.filter_list_alt)
                        ],
                      )),
                  /*Text(
                    widget.dropDown.bottomSheetTitle ?? 'Title',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),*/
                  Expanded(
                    child: Container(),
                  ),

                  /// Done button
                  Visibility(
                    visible: widget.dropDown.enableMultipleSelection,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () {
                            List<SelectedListItem> selectedList = widget
                                .dropDown.dataList
                                .where((element) => element.isSelected == true)
                                .toList();
                            List<ReferansKunye> selectedNameList = [];

                            for (var element in selectedList) {
                              selectedNameList.add(element.referansKunye);
                            }

                            widget.dropDown.selectedItems
                                ?.call(selectedNameList);
                            _onUnfocusKeyboardAndPop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.dropDown.submitButtonColor ??
                                Colors.blue,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child:
                              Text(widget.dropDown.submitButtonText ?? 'Done')),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: context.padding.horizontalNormal,
                  child: ElevatedButton(
                      onPressed: () {
                        for (var element in mainList) {
                          element.isSelected = false;
                          setState(() {});
                        }
                        totalSelectedCount = 0;
                      },
                      child: const Text("Seçilenleri Bırak")),
                ),
                Padding(
                  padding: context.padding.horizontalNormal,
                  child: ElevatedButton(
                      onPressed: () {
                        for (var element in mainList) {
                          if (totalSelectedCount >= 100) {
                            break;
                          } else {
                            element.isSelected = true;
                            setState(() {});
                            totalSelectedCount++;
                          }
                        }
                      },
                      child: const Text("Tümünü Seç")),
                ),
              ],
            ),

            /// A [TextField] that displays a list of suggestions as the user types with clear button.
            Row(
              children: [
                Expanded(
                  child: _AppTextField(
                    dropDown: widget.dropDown,
                    onTextChanged: _buildSearchList,
                    onClearTap: _onClearTap,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Toplam künye sayısı: ${mainList.length}    "),
                Text("Seçilen künye sayısı: $totalSelectedCount"),
              ],
            ),

            /// Listview (list of data with check box for multiple selection & on tile tap single selection)
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: mainList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    // ignore: sort_child_properties_last
                    child: Material(
                      elevation: 10,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
                          child: ListTile(
                            title: Text(
                              "${mainList[index].referansKunye.malinAdi ??
                                      "boş"}  ${mainList[index].referansKunye.malinCinsi ??
                                      "boş"}",
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Kalan Miktar: ${mainList[index].referansKunye.kalanMiktar ?? "boş"} ${mainList[index].referansKunye.malinMiktarBirimAd ?? "boş"}"),
                                Row(
                                  children: [
                                    Text(
                                      parseDate(mainList[index]
                                          .referansKunye
                                          .bildirimTarihi!),
                                    ),
                                    Text(
                                        "  Plaka: ${mainList[index].referansKunye.aracPlakaNo ?? "null"}"),
                                  ],
                                ),
                              ],
                            ),
                            trailing: mainList[index].isSelected
                                ? const Icon(
                                    Icons.check_box,
                                    color: Color.fromRGBO(70, 76, 222, 1),
                                  )
                                : const Icon(Icons.check_box_outline_blank),
                          ),
                        ),
                      ),
                    ),
                    onTap: widget.dropDown.enableMultipleSelection
                        ? () {

                            setState(() {
                              if (mainList[index].isSelected) {
                                totalSelectedCount--;
                              } else {
                                totalSelectedCount++;
                              }
                              mainList[index].isSelected =
                                  !mainList[index].isSelected;
                            });
                          }
                        : () {
                            widget.dropDown.selectedItem?.call(
                                (mainList[index].value != null)
                                    ? mainList[index].value ?? ''
                                    : mainList[index].referansKunye.malinAdi ??
                                        "boş");
                            _onUnfocusKeyboardAndPop();
                          },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// This helps when search enabled & show the filtered data in list.
  _buildSearchList(String userSearchTerm) {
    final results = widget.dropDown.dataList
        .where((element) => (element.referansKunye.malinAdi ?? "boş")
            .toLowerCase()
            .contains(userSearchTerm.toLowerCase()))
        .toList();
    if (userSearchTerm.isEmpty) {
      mainList = widget.dropDown.dataList;
    } else {
      mainList = results;
    }
    setState(() {});
  }

  /// This helps when want to clear text in search text field.
  void _onClearTap() {
    widget.dropDown.searchController.clear();
    mainList = widget.dropDown.dataList;
    setState(() {});
  }

  /// This helps to unfocus the keyboard & pop from the bottom sheet.
  _onUnfocusKeyboardAndPop() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }
}

/// This is search text field class.
class _AppTextField extends StatefulWidget {
  DropDown dropDown;
  Function(String) onTextChanged;
  VoidCallback onClearTap;

  _AppTextField(
      {required this.dropDown,
      required this.onTextChanged,
      required this.onClearTap,
      Key? key})
      : super(key: key);

  @override
  State<_AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<_AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: widget.dropDown.searchController,
        cursorColor: Colors.black,
        onChanged: (value) {
          widget.onTextChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.dropDown.searchBackgroundColor ?? Colors.black12,
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 15),
          hintText: widget.dropDown.searchHintText ?? 'Search',
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          prefixIcon: const IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
          suffixIcon: GestureDetector(
            onTap: widget.onClearTap,
            child: const Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
