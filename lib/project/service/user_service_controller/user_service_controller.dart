import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/model/response_model/IResponse_model.dart';

import '../../model/user/my_user_model.dart';
import '../firebase/auth/fireabase_auth_service.dart';
import '../firebase/firestore/firestore_service.dart';

class UserServiceController {
  // add a base

  static UserServiceController? _instance;
  static UserServiceController get instance =>
      _instance ??= UserServiceController._init();

  late FirebaseAuthService _firebaseAuthService;
  late FirestoreService _firestoreService;
  UserServiceController._init() {
    _firebaseAuthService = FirebaseAuthService.instance;
    _firestoreService = FirestoreService.instance;
  }

  Future<IResponseModel<MyUser?>> getCurrentUser() async {
    IResponseModel<MyUser?> response =
        await _firebaseAuthService.getCurrentUser();
    if (response.data != null) {
      return await _firestoreService
          .readUserInformations(response.data!.phoneNumber ?? "");
    }
    return response;
  }

  Future<IResponseModel<MyUser?>> createUserWithEmailandPassword(
      String email, String password, String name) async {
    IResponseModel<MyUser?> response = await _firebaseAuthService
        .createUserWithEmailandPassword(email, password, name);
    if (response.error != null) {
      return response;
    } else if (response.data != null) {

      return await _firestoreService.saveUserInformations(response.data!);
    }
    return response;
  }

  Future<IResponseModel<MyUser?>> signInWithEmailandPassword(
      String email, String password) async {
    IResponseModel<MyUser?> response =
        await _firebaseAuthService.signInWithEmailandPassword(email, password);

    if (response.error != null) {
      return response;
    } else if (response.data != null) {
      IResponseModel<MyUser?> responseModel = await _firestoreService
          .readUserInformations(response.data!.phoneNumber ?? "");
      MyUser? userFromService = responseModel.data;
      if (userFromService != null) {
        response =
            await _firestoreService.saveUserInformations(userFromService);
      }
      return response;
    }
    return response;
  }

  Future<IResponseModel<MyUser?>> signInWithCredential(
      AuthCredential credential) async {
    IResponseModel<MyUser?> response =
        await _firebaseAuthService.signInWithCredential(credential);
    if (response.error != null) {

      return response;
    } else if (response.data != null) {

      IResponseModel<MyUser?> responseModel = await _firestoreService
          .readUserInformations(response.data!.phoneNumber ?? "");
      MyUser? userFromService = responseModel.data;
      if (userFromService == null) {

        return await _firestoreService.saveUserInformations(
          response.data!,
        );
      } else {
        return responseModel;
      }
    }
    return response;
  }

  Future<IResponseModel<MyUser>> signOut() async {
    return await _firebaseAuthService.signOut();
  }
}
