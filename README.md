
# Firestore Service Framework

Bu proje, Firebase Firestore ile veri yönetimi işlemleri için temel soyutlamalar ve hizmet sınıfları sağlar.

## Dosyalar ve Açıklamaları

### 1. **store_base.dart**
Bu dosya, Firestore için temel bir soyutlama sunar. Diğer sınıflar bu soyutlamayı genişleterek belirli veri işleme işlevlerini uygular.

#### Sağlanan Soyut İşlevler:
- **saveUserInformations**: Kullanıcı bilgilerini kaydetmek için bir soyutlama (şu anda yorumlanmış durumda).
- **readUserInformations**: Kullanıcı bilgilerini okumak için bir soyutlama (şu anda yorumlanmış durumda).

### 2. **firestore_service.dart**
Bu dosya, Firestore ile etkileşim kurmak için bir hizmet sınıfı içerir. `StoreBase` sınıfını genişleterek Firestore işlemlerini yönetir.

#### Öne Çıkan Özellikler:
- **Statik Singleton Yapı**: `FirestoreService.instance` ile tek bir örnek üzerinden yönetim sağlanır.
- **FirebaseFirestore Başlatma**: Firebase Firestore ile bağlantı kurar.
- **Alt Dosyalarla Entegrasyon**: Veritabanı işlemleri `firestore_service_read.dart` ve `firestore_service_save.dart` dosyalarına ayrılmıştır.

#### Kullanılan Paketler:
- **cloud_firestore**: Firestore veritabanı ile etkileşim.
- **device_info_plus**: Cihaz bilgilerini elde etmek için.
- **custom cache managers**: Uygulama önbellek yönetimi için özel sınıflar.
- **response_model**: API yanıtlarını modellemek için sınıflar.
- **time_service**: Zaman senkronizasyonu ve tarih işlemleri için.

## Kullanım

Bu sınıflar, Firestore tabanlı bir Flutter uygulamasında veri yönetimi ve senkronizasyon işlemlerini kolaylaştırmak için tasarlanmıştır.

### Örnek Kullanım

```dart
void main() {
  // FirestoreService singleton kullanımı
  final firestoreService = FirestoreService.instance;

  // Firestore işlemleri
  firestoreService.someFunction();
}
```

## Gereksinimler

- Firebase Firestore SDK
- `device_info_plus` kütüphanesi
- Projenin özel önbellek ve zaman servisleri

## Katkıda Bulunma

Projeye katkıda bulunmak için:

1. Fork yapın.
2. Yeni bir dal oluşturun (`git checkout -b feature/isim`).
3. Değişikliklerinizi yapın ve commit edin (`git commit -m 'Yeni özellik ekleme'`).
4. Değişikliklerinizi gönderin (`git push origin feature/isim`).
5. Bir pull request oluşturun.

## Lisans

Bu proje MIT lisansı ile lisanslanmıştır.
