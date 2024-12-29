import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../project/model/user/my_user_model.dart';
import '../../../../enum/fireauth_request_enum.dart';
import '../../../../exception/custom_exception_firebase.dart';
import '../../../../model/error_model/base_error_model.dart';
import '../../../../model/firebase/firebase_auth_request_model.dart';
import '../../../../model/response_model/IResponse_model.dart';
import '../../../../model/response_model/response_model.dart';
import 'IFirebase_auth.dart';

class FirebaseAuthCustom implements IFirebaseAuth {
  @override
  Future<IResponseModel<MyUser>> get(
      {required FirebaseAuthTypes type,
      required FirebaseAuth auth,
      AuthCredential? credential,
      FirebaseAuthRequestModel? requestModel}) async {
    try {
      switch (type) {
        case FirebaseAuthTypes.login:
          UserCredential userCredential = await auth.signInWithEmailAndPassword(
              email: requestModel!.email, password: requestModel.password);
          final response = _userFromFirebase(userCredential.user);
          return ResponseModel<MyUser>(data: response);
        case FirebaseAuthTypes.register:
          UserCredential userCredential =
              await auth.createUserWithEmailAndPassword(
                  email: requestModel!.email, password: requestModel.password);
          final response = _userFromFirebase(userCredential.user);
          return ResponseModel<MyUser>(data: response);
        case FirebaseAuthTypes.currentUser:
          return ResponseModel<MyUser>(
              data: _userFromFirebase(auth.currentUser));

        case FirebaseAuthTypes.signOut:
          await signOut(auth);
          return ResponseModel<MyUser>();
        case FirebaseAuthTypes.credential:
          if (credential != null) {
            UserCredential userCredential =
                await auth.signInWithCredential(credential);
            final response = _userFromFirebase(userCredential.user);
            return ResponseModel<MyUser>(data: response);
          } else {
            return ResponseModel<MyUser>(
                error: BaseError(
                    message: "credential olarak gönderildi ", statusCode: 400));
          }
      }
    } on FirebaseAuthException catch (e) {
      String message = FirebaseCustomExceptions.convertFirebaseMessage(e.code);
      return ResponseModel<MyUser>(
          error: BaseError(message: message, statusCode: 400));
    } catch (e) {
      return ResponseModel<MyUser>(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
  }

  Future<bool> signOut(FirebaseAuth auth) async {
    await auth.signOut();
    return true;
  }

  MyUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return MyUser(phoneNumber: user.phoneNumber);
    }
  }
}
