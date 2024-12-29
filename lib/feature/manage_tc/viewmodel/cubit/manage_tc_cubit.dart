import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/add_tc_page/viewmodel/cubit/add_tc_cubit.dart';
import '../../../add_tc_page/view/add_tc_page.dart';
import '../../../../project/cache/bildirimci_cache_manager.dart';

import '../../../../core/enum/preferences_keys_enum.dart';
import '../../../../core/enum/subscription_types_enum.dart';
import '../../../../project/cache/app_cache_manager.dart';
import '../../../../project/cache/user_cache_manager.dart';
import '../../../../project/model/user/my_user_model.dart';

part 'manage_tc_state.dart';

class ManageTcCubit extends Cubit<ManageTcState> {
  ManageTcCubit() : super(ManageTcInitial()) {}
  emitInitial() {
    emit(ManageTcInitial());
  }

  void addTc(BuildContext context) {
    context.read<AddTcCubit>().clearAllFields();
    Navigator.pushNamed(context, AddTcPage.name);
  }

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();
}
