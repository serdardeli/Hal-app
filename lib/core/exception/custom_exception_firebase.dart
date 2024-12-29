class FirebaseCustomExceptions {
  static String convertFirebaseMessage(String exceptionCode) {
    switch (exceptionCode) {
      case 'email-already-in-use':
        return "bu email sistemde kayıtlı";
      case 'user-not-found':
        return "kullanıcı bulunamadı";
      case 'too-many-requests':
        return "çok fazla işlem yaptınız bir süre beklemelisiniz";
      case 'wrong-password':
        return "hatalı şifre";
      default:
        return exceptionCode;
    }
  }
}

 

/*
 if (e.code == 'user-not-found') {

      } else if (e.code == 'wrong-password') {

      }*/

      /**
       * if (e.code == 'weak-password') {

      } else if (e.code == 'email-already-in-use') {

      }
       * 
       */