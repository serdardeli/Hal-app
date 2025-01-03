
# Cache Managers - Flutter Cache Management

Bu proje, Flutter uygulamalarında veri önbellekleme işlemlerini kolaylaştırmak için geliştirilmiş önbellek yöneticilerini içerir. Her bir dosya, belirli bir veri türü veya modül için özelleştirilmiş bir önbellek yönetimi sağlar.

## İçerik

Klasörde bulunan önbellek yönetim dosyaları:

- **app_cache_manager.dart**: Genel uygulama önbellek yönetimi için kullanılır.
- **bildirimci_cache_manager.dart**: Bildirim gönderenlerle ilgili önbellek yönetimi.
- **bildirim_cache_manager.dart**: Bildirimlerin önbellekleme işlemleri.
- **bildirim_list_cache_manager_new.dart**: Bildirim listesi için önbellekleme yönetimi.
- **depo_cache_manager.dart**: Depo bilgilerini önbellekleme.
- **driver_list_cache_manager.dart**: Sürücü listesi önbellek yönetimi.
- **hal_ici_isyeri_cache_manager.dart**: Hal içindeki iş yerlerini önbellekleme.
- **last_custom_notifications_cache_manager.dart**: Son özel bildirimlerin önbelleklemesi.
- **musteri_depo_cache_manager.dart**: Müşteriye ait depo verilerinin önbelleklemesi.
- **musteri_hal_ici_isyeri_cache_manager.dart**: Müşteri ve hal içi iş yeri verilerinin önbelleklemesi.
- **musteri_list_cache_manager.dart**: Müşteri listesi önbellek yönetimi.
- **musteri_sube_cache_manager.dart**: Müşteri ve şube bilgilerini önbellekleme.
- **mysoft_user_cache_mananger.dart**: MySoft kullanıcı bilgileri için önbellek yönetimi.
- **sube_cache_manager.dart**: Şube bilgilerini önbellekleme.
- **trial.dart**: Test amaçlı bir dosya.
- **uretici_list_cache_manager.dart**: Üretici listesi önbellek yönetimi.
- **user_cache_manager.dart**: Genel kullanıcı önbellek yönetimi.

## Kullanım

Bu dosyalar, Flutter uygulamalarında veri önbellekleme işlemlerini düzenlemek için kullanılabilir. Örneğin, bir API'den gelen verileri önbelleğe alarak performansı artırabilir ve gereksiz ağ isteklerini azaltabilirsiniz.

### Örnek Kullanım

```dart
import 'app_cache_manager.dart';

void main() {
  final cacheManager = AppCacheManager();

  cacheManager.saveData('key', 'value');
  final data = cacheManager.getData('key');

  print(data); // Çıktı: value
}
```

## Katkıda Bulunma

Projeye katkıda bulunmak isterseniz:

1. Fork yapın.
2. Yeni bir dal oluşturun (`git checkout -b feature/isim`).
3. Değişikliklerinizi yapın ve commit edin (`git commit -m 'Yeni özellik ekleme'`).
4. Değişikliklerinizi gönderin (`git push origin feature/isim`).
5. Bir pull request oluşturun.

## Lisans

Bu proje MIT lisansı ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakabilirsiniz.
