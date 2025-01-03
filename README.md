
# Ns Notification Center

Bu proje, Firestore veritabanı ile veri okuma ve yazma işlemlerini yönetmek için uzantılar içermektedir. İki temel dosya, `firestore_service_read.dart` ve `firestore_service_save.dart`, veri işlemlerini ayrıntılı bir şekilde yönetmek için tasarlanmıştır.

## Dosyalar

### 1. **firestore_service_read.dart**
Bu dosya, Firestore'dan veri okuma işlemleri için uzantılar içerir.

#### Öne Çıkan İşlevler:
- **readUserSubscriptionInfo**: Kullanıcının abonelik bilgilerini okuyarak `SubscriptionStartModel` nesnesi döndürür.
- **readBildirimciInformations**: Telefon numarasına göre kullanıcı bilgilerini döndürür.
- **fetchJustUserData**: Belirli bir kullanıcı verisini getirir.
- **fetchAllUsersData**: Tüm kullanıcı verilerini döndürür.
- **fetchUserAllData**: Kullanıcının tüm ilişkili verilerini okur ve önbelleğe kaydeder.

### 2. **firestore_service_save.dart**
Bu dosya, Firestore'a veri yazma işlemleri için uzantılar içerir.

#### Öne Çıkan İşlevler:
- **saveStartSubscriptionInfo**: Kullanıcı abonelik başlangıç bilgilerini kaydeder.
- **savefirstUserInfoDetail**: Kullanıcının ilk giriş bilgilerini kaydeder.
- **saveUserInformations**: Kullanıcı bilgilerini günceller veya yeni bir kullanıcı oluşturur.
- **saveBildirimciTc**: Kullanıcının TC kimlik bilgilerini kaydeder.
- **saveAllUserData**: Kullanıcı verilerini toplu olarak Firestore'a kaydeder.

## Kullanım

Bu uzantılar, Firestore işlemlerini kolaylaştırmak ve kod tekrarını azaltmak için tasarlanmıştır.

### Örnek Kullanım

```dart
import 'firestore_service_read.dart';
import 'firestore_service_save.dart';

void main() async {
  final firestoreService = FirestoreService();

  // Abonelik bilgisi okuma
  final subscriptionInfo = await firestoreService.readUserSubscriptionInfo();

  // Kullanıcı bilgisi kaydetme
  final newUser = MyUser(phoneNumber: "1234567890", name: "John Doe");
  await firestoreService.saveUserInformations(newUser);
}
```

## Gereksinimler

- Firestore SDK
- `DeviceInfoPlugin` kütüphanesi
- Zaman senkronizasyonu için `TimeService`

## Katkıda Bulunma

Projeye katkıda bulunmak için:

1. Fork yapın.
2. Yeni bir dal oluşturun (`git checkout -b feature/isim`).
3. Değişikliklerinizi yapın ve commit edin (`git commit -m 'Yeni özellik ekleme'`).
4. Değişikliklerinizi gönderin (`git push origin feature/isim`).
5. Bir pull request oluşturun.

## Lisans

Bu proje MIT lisansı ile lisanslanmıştır.
