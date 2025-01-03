
# RESTul - Flutter Project Modules

Bu proje, Flutter uygulamasında kullanılan çeşitli modülleri içerir. Her bir modül, belirli bir işlevsellik veya veri işleme gereksinimi için tasarlanmıştır.

## İçerik

Klasör ve dosyaların açıklamaları:

- **izibiz**: İZİBİZ ile entegrasyon sağlayan modüller. Elektronik fatura ve diğer servisler için kullanılabilir.
- **mysoft**: MySoft ile ilgili işlemleri yöneten modüller.
- **tc**: TC kimlik doğrulama veya ilgili işlemleri içeren modüller.
- **time**: Zaman yönetimi ve tarih işlemleri için kullanılan modüller.
- **user_service_controller**: Kullanıcı hizmetleri ve kontrolleri için gerekli modüller.
- **fatura**: Fatura işleme ve yönetim modülleri.
- **hal**: Hal sistemiyle ilgili veri işleme ve yönetim modülleri.

## Kullanım

Bu modüller, Flutter projelerinde farklı veri işlemleri ve işlevsellikleri sağlamak için kullanılabilir. Örneğin, elektronik fatura gönderimi, kullanıcı hizmetleri, tarih işlemleri gibi işlevler bu modüllerle kolayca yönetilebilir.

### Örnek Kullanım

```dart
import 'izibiz/fatura_service.dart';

void main() {
  final faturaService = FaturaService();

  faturaService.createFatura('12345', 1000.50);
  print('Fatura başarıyla oluşturuldu.');
}
```

## Katkıda Bulunma

Projeye katkıda bulunmak için:

1. Fork yapın.
2. Yeni bir dal oluşturun (`git checkout -b feature/isim`).
3. Değişikliklerinizi yapın ve commit edin (`git commit -m 'Yeni özellik ekleme'`).
4. Değişikliklerinizi gönderin (`git push origin feature/isim`).
5. Bir pull request oluşturun.

## Lisans

Bu proje MIT lisansı ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakabilirsiniz.
