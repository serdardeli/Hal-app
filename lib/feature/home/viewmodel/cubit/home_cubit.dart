import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    pageController = PageController();
  }
  int _currentIndex = 0;
  late PageController pageController;

  int get currentIndex => _currentIndex;
  set currentIndex(int value) {
    _currentIndex = value;
    emit(HomeInitial());
  }

  @override
  Future<void> close() {
    // TODO: implement close
    pageController.dispose();

    return super.close();
  }

  void refreshAllIndex() {
    _currentIndex = 0;
    //pageController.jumpToPage(0);

    emit(HomeInitial());
  }
}
