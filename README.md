
# Flutter UI Project

Bu proje, Flutter ile geliştirilmiş bir kullanıcı arayüzü (UI) ve yönetim sistemi içerir. Farklı ekranlar ve modüller, TC kimlik yönetimi ve ilgili işlevler için tasarlanmıştır.

## İçerik

Klasör ve dosyaların açıklamaları:

- **manage_tc**: TC kimlik bilgilerini yönetmek için ana modül.
- **remove_excess_tc_page**: Fazla TC kimliklerinin kaldırılması için kullanılan arayüz.
- **settings**: Uygulama ayarlarını yönetmek için kullanılan modül.
- **subscriptions**: Abonelik işlemleri ve yönetimi için arayüz.
- **add_tc_page**: Yeni TC kimlik ekleme işlemleri için kullanılan ekran.
- **auth**: Kimlik doğrulama işlemlerini yöneten modül.
- **helper**: Yardımcı işlevler ve ortak bileşenler.
- **home**: Ana ekran modülü.
- **launch**: Uygulamanın başlangıç ekranı ve giriş noktası.

## Kullanım

Bu proje, Flutter uygulamalarında TC kimlik yönetimi ve ilgili işlevlerin gerçekleştirilmesi için kullanılabilir. Kullanıcı dostu bir arayüz sunar ve farklı modüllerle genişletilebilir.

### Örnek Kullanım

```dart
import 'manage_tc/add_tc_page.dart';

void main() {
  runApp(MaterialApp(
    home: AddTcPage(),
  ));
}
```

## Özellikler

- TC kimlik bilgilerini ekleme ve kaldırma.
- Abonelik ve kimlik doğrulama işlemleri.
- Uygulama ayarlarını özelleştirme.
- Kullanıcı dostu başlangıç ve ana ekran tasarımı.

## Katkıda Bulunma

Projeye katkıda bulunmak için:

1. Fork yapın.
2. Yeni bir dal oluşturun (`git checkout -b feature/isim`).
3. Değişikliklerinizi yapın ve commit edin (`git commit -m 'Yeni özellik ekleme'`).
4. Değişikliklerinizi gönderin (`git push origin feature/isim`).
5. Bir pull request oluşturun.

## Lisans

Bu proje MIT lisansı ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakabilirsiniz.
