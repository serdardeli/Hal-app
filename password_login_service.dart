import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordLoginService {
  static PasswordLoginService? _instance;
  static PasswordLoginService get instance {
    _instance ??= PasswordLoginService._init();
    return _instance!;
  }

  late FirebaseFirestore _firebaseFirestore;

  PasswordLoginService._init() {
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  Future<bool> login(String phone, password) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firebaseFirestore.collection('new_users').doc(phone).get();

      if (documentSnapshot.exists &&
          documentSnapshot.data() != null &&
          documentSnapshot.data() is Map) {
        var result = (documentSnapshot.data() as Map<String, dynamic>);
        print(result);
        print(result["password"]);
        print(password);
        print(result["password"].runtimeType);
        print(password.runtimeType);
        print(result["password"] == password);
        print('---');
        print(result["password"].contains(' ')); // false
        print(password.contains(' ')); // false
        if (result["password"] == password) {
          return true;
        } else {
          throw Exception("Hatalı şifre");
        }
      } else {
        throw Exception("Kullanıcı bulunamadı");
      }
    } catch (e) {
      rethrow;
    }
  }
}
