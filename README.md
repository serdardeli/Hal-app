
# Firebase Authentication Services

Bu proje, Firebase Authentication ve kullanıcı oturum yönetimi işlemlerini gerçekleştirmek için çeşitli sınıflar ve soyutlamalar içerir. Aşağıda her dosyanın işlevleri açıklanmıştır.

## Dosyalar ve Açıklamaları

### 1. **fireabase_auth_service.dart**
Bu dosya, Firebase Authentication ile kullanıcı işlemleri gerçekleştirmek için bir hizmet sınıfı içerir.

#### Sağlanan İşlevler:
- **createUserWithEmailandPassword**: Kullanıcıyı e-posta ve şifre ile oluşturur.
- **getCurrentUser**: Mevcut oturum açmış kullanıcıyı döndürür.
- **signInWithEmailandPassword**: E-posta ve şifre ile giriş yapar.
- **signOut**: Kullanıcıyı oturumdan çıkarır.
- **signInWithCredential**: Kimlik bilgileriyle giriş yapar (örneğin, Google veya Facebook).

### 2. **password_login_service.dart**
Bu dosya, kullanıcıların Firestore veritabanındaki verilerini doğrulayarak oturum açma işlemlerini gerçekleştirir.

#### Sağlanan İşlevler:
- **login**: Telefon numarası ve şifre doğrulaması yapar, şifre doğru ise girişe izin verir.

### 3. **auth_base.dart**
Bu dosya, kimlik doğrulama işlemleri için bir soyutlama sağlar. Diğer sınıflar bu soyutlamayı uygulayarak farklı doğrulama yöntemlerini yönetebilir.

#### Sağlanan Soyut İşlevler:
- **getCurrentUser**: Mevcut oturum açmış kullanıcıyı döndürmek için bir soyutlama.
- **signOut**: Kullanıcı oturumunu sonlandırmak için soyutlama.
- **signInWithCredential**: Kimlik bilgileriyle giriş yapmak için soyutlama.
- **signInWithEmailandPassword**: E-posta ve şifreyle giriş yapmak için soyutlama.
- **createUserWithEmailandPassword**: Kullanıcıyı e-posta ve şifreyle oluşturmak için soyutlama.

## Kullanım

Bu dosyalar, Firebase Authentication işlemlerini kolaylaştırmak ve uygulama içinde oturum yönetimi sağlamak için tasarlanmıştır.

### Örnek Kullanım

```dart
void main() async {
  // FirebaseAuthService ile kullanıcı oluşturma
  final authService = FirebaseAuthService.instance;
  await authService.createUserWithEmailandPassword(
      "test@example.com", "password123", "John Doe");

  // PasswordLoginService ile giriş yapma
  final loginService = PasswordLoginService.instance;
  bool loginSuccess = await loginService.login("1234567890", "password123");
  print("Giriş başarılı mı? $loginSuccess");
}
```

## Gereksinimler

- Firebase Authentication SDK
- Firebase Firestore SDK

## Katkıda Bulunma

Projeye katkıda bulunmak için:

1. Fork yapın.
2. Yeni bir dal oluşturun (`git checkout -b feature/isim`).
3. Değişikliklerinizi yapın ve commit edin (`git commit -m 'Yeni özellik ekleme'`).
4. Değişikliklerinizi gönderin (`git push origin feature/isim`).
5. Bir pull request oluşturun.

## Lisans

Bu proje MIT lisansı ile lisanslanmıştır.
