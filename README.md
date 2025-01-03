
# Kayitli Kisi Model - Flutter Data Models

Bu proje, Flutter uygulamaları için geliştirilmiş çeşitli veri modellerini içermektedir. Modeller, farklı veri yapıları ve API yanıtlarını yönetmek için tasarlanmıştır.

## İçerik

Bu proje aşağıdaki dosya ve klasörleri içerir:

- **kayitli_kisi_model**: Kayıtlı kişilerle ilgili verilerin yönetimi için kullanılan model.
- **malin_gidecegi_yer**: Malların gönderileceği yer bilgilerini tanımlayan model.
- **malin_gidecegi_yer_info_model**: Malların gönderileceği yer hakkında daha ayrıntılı bilgi sağlayan model.
- **musteri_model**: Müşteri bilgilerini temsil eden model.
- **mysoft_giden_fatura_model**: Giden faturalarla ilgili verileri yöneten model.
- **mysoft_giden_irsaliye_model.dart**: Giden irsaliyelerle ilgili model dosyası.
- **mysoft_user_model**: Kullanıcı bilgileri için veri modeli.
- **referans_kunye**: Referans bilgilerini tanımlayan model.
- **sube**: Şube bilgilerini temsil eden model.
- **subscription**: Abonelik verilerini yönetmek için kullanılan model.
- **subscription_start_model**: Abonelik başlangıç bilgilerini içeren model.
- **uretici_model**: Üretici bilgilerini tanımlayan model.
- **urun**: Ürün bilgilerini yöneten model.
- **user**: Genel kullanıcı model dosyası.
- **bildirim**: Bildirimlerle ilgili model dosyası.
- **bildirim_kayit_response_model.dart**: Bildirim kaydı yanıt model dosyası.
- **bildirimci**: Bildirimleri yöneten servis modeli.
- **custom_notification_save_model.dart**: Özel bildirimlerin kaydedilmesi için model.
- **depo**: Depo bilgilerini tanımlayan model.
- **driver_model**: Sürücü bilgileriyle ilgili model.
- **hal_base_response_model.dart**: API yanıtlarını yönetmek için temel model.
- **hal_ici_isyeri**: Hal içindeki iş yerlerini tanımlayan model.
- **hks_bildirim_model**: HKS bildirim verileri için model.
- **hks_user**: HKS kullanıcı modeli.

## Kullanım

Bu modeller, Flutter projelerinde veri yapılarını temsil etmek ve API yanıtlarını işlemek için kullanılabilir. Her model bir `class` olarak tanımlanmış olup, projede kolayca entegre edilebilir.

### Örnek Kullanım

```dart
import 'mysoft_giden_irsaliye_model.dart';

void main() {
  final irsaliye = MysoftGidenIrsaliyeModel(
    id: 1,
    description: "Test İrsaliye",
  );

  print(irsaliye.toJson());
}
```

## Katkıda Bulunma

Projeye katkıda bulunmak isterseniz, aşağıdaki adımları izleyebilirsiniz:

1. Fork yapın.
2. Yeni bir dal oluşturun (`git checkout -b feature/isim`).
3. Değişikliklerinizi yapın ve commit edin (`git commit -m 'Yeni özellik ekleme'`).
4. Değişikliklerinizi gönderin (`git push origin feature/isim`).
5. Bir pull request oluşturun.

## Lisans

Bu proje MIT lisansı ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakabilirsiniz.
