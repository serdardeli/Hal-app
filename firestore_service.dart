import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:hal_app/project/model/bildirim/bildirim_model.dart';
import 'package:hal_app/project/model/uretici_model/uretici_model.dart';
import '../../../../core/enum/preferences_keys_enum.dart';
import '../../../cache/app_cache_manager.dart';
import '../../../cache/bildirim_list_cache_manager_new.dart';
import '../../../cache/bildirimci_cache_manager.dart';
import '../../../cache/uretici_list_cache_manager.dart';
import '../../../cache/user_cache_manager.dart';
import '../../../model/custom_notification_save_model.dart/custom_notification_save_model.dart';
import '../../../model/bildirimci/bildirimci_model.dart';
import '../../../model/subscription/subscription_model.dart';

import '../../../../../core/model/error_model/base_error_model.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../core/model/response_model/response_model.dart';

import '../../../model/subscription_start_model/subscription_start_model.dart';
import '../../../model/user/my_user_model.dart';
import '../../time/time_service.dart';
import 'base/store_base.dart';

part './sub/firestore_service_read.dart';
part './sub/firestore_service_save.dart';

class FirestoreService implements StoreBase {
  static FirestoreService? _instace;
  static FirestoreService get instance {
    _instace ??= FirestoreService._init();
    return _instace!;
  }

  late final FirebaseFirestore _firestore;

  FirestoreService._init() {
    _firestore = FirebaseFirestore.instance;
  }
}
