import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'saved_notification_page_general_state.dart';

class SavedNotificationPageGeneralCubit
    extends Cubit<SavedNotificationPageGeneralState> {
  SavedNotificationPageGeneralCubit()
      : super(SavedNotificationPageGeneralInitial()) {
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
    emit(SavedNotificationPageGeneralInitial());
  }

  void closeSearch(BuildContext context) {
    if (isSearchOpen) {
      isSearchOpen = !isSearchOpen;

      myFocusNode.unfocus();
    }

    emit(SavedNotificationPageGeneralInitial());
  }

  void textFormFieldChanged() {
    emit(SavedNotificationPageGeneralInitial());
  }
}
