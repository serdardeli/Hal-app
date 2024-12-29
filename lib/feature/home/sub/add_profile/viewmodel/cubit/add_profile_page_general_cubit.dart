import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'add_profile_page_general_state.dart';

class AddProfilePageGeneralCubit extends Cubit<AddProfilePageGeneralState> {
  AddProfilePageGeneralCubit() : super(AddProfilePageGeneralInitial()) {
    searchTextEditingController = TextEditingController();
    myFocusNode = FocusNode();
  }
  bool isSearchOpen = false;
  late FocusNode myFocusNode;

  late TextEditingController searchTextEditingController;
  void closeKeyBoardAndUnFocus() {
    if (isSearchOpen) {
      isSearchOpen = !isSearchOpen;
      searchTextEditingController.clear();

      myFocusNode.unfocus();
    }
  }

  void changeIsSearch(BuildContext context) {
    isSearchOpen = !isSearchOpen;
    if (isSearchOpen) {
      FocusScope.of(context).requestFocus(myFocusNode);
    }
    if (!isSearchOpen) {
      myFocusNode.unfocus();
    }
    emit(AddProfilePageGeneralInitial());
  }

  void closeSearch(BuildContext context) {
    if (isSearchOpen) {


      isSearchOpen = !isSearchOpen;

      myFocusNode.unfocus();
    }

    emit(AddProfilePageGeneralInitial());
  }

  void textFormFieldChanged() {
    emit(AddProfilePageGeneralInitial());
  }
}
