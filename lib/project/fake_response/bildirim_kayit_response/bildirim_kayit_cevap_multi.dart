class FakeBildirimKayitCevap {
  static FakeBildirimKayitCevap? _instance;

  static FakeBildirimKayitCevap get instance =>
      _instance ??= FakeBildirimKayitCevap._();

  FakeBildirimKayitCevap._();

  String get getCokluBildirimKayitCevapOlumlu => '''
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <BaseResponseMessageOf_ListOf_BildirimKayitCevap xmlns="http://www.gtb.gov.tr//WebServices">
            <HataKodlari xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Core.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
                <a:ErrorModel>
                    <a:HataKodu>1</a:HataKodu>
                    <a:Mesaj>GTBWSRV0000002</a:Mesaj>
                </a:ErrorModel>
            </HataKodlari>
            <IslemKodu>GTBWSRV0000001</IslemKodu>
            <Sonuc xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
                <a:BildirimKayitCevap>
                    <a:AracPlakaNo>67DU768</a:AracPlakaNo>
                    <a:BelgeNo>0</a:BelgeNo>
                    <a:BelgeTipi>207</a:BelgeTipi>
                    <a:HataKodu>0</a:HataKodu>
                    <a:KayitTarihi>2022-08-04T18:01:09.2721403+03:00</a:KayitTarihi>
                    <a:MalinCinsiId>1859</a:MalinCinsiId>
                    <a:MalinKodNo>438</a:MalinKodNo>
                    <a:MalinMiktari>3000</a:MalinMiktari>
                    <a:MalinSahibAdi>EYLÜL14 TARIM TİCARET LİMİTED ŞİRKETİ </a:MalinSahibAdi>
                    <a:Mesaj i:nil="true"/>
                    <a:MiktarBirimId>74</a:MiktarBirimId>
                    <a:RusumMiktari>0</a:RusumMiktari>
                    <a:UniqueId>asdfasgaADRGRGQEHWEQrsynsrynszryjnsryjnrsyyTHasdasWRTHWRTHWTRadsfasadasdf</a:UniqueId>
                    <a:UreticisininAdUnvani>MUSTAFA KEÇECİ</a:UreticisininAdUnvani>
                    <a:UretimBeldeId>2448</a:UretimBeldeId>
                    <a:UretimIlId>19</a:UretimIlId>
                    <a:UretimIlceId>517</a:UretimIlceId>
                    <a:UretimSekli>28</a:UretimSekli>
                      <a:YeniKunyeNo>1194389220015932461</a:YeniKunyeNo>
                </a:BildirimKayitCevap>
                <a:BildirimKayitCevap>
                    <a:AracPlakaNo>06den06</a:AracPlakaNo>
                    <a:BelgeNo>0</a:BelgeNo>
                    <a:BelgeTipi>207</a:BelgeTipi>
                    <a:HataKodu>0</a:HataKodu>
                    <a:KayitTarihi>2022-08-04T18:01:09.2721403+03:00</a:KayitTarihi>
                    <a:MalinCinsiId>1166</a:MalinCinsiId>
                    <a:MalinKodNo>300</a:MalinKodNo>
                    <a:MalinMiktari>3000</a:MalinMiktari>
                    <a:MalinSahibAdi>EYLÜL14 TARIM TİCARET LİMİTED ŞİRKETİ </a:MalinSahibAdi>
                    <a:Mesaj i:nil="true"/>
                    <a:MiktarBirimId>74</a:MiktarBirimId>
                    <a:RusumMiktari>0</a:RusumMiktari>
                    <a:UniqueId>asdfasgaADRGRGQEHWEQrsynsrynszryjnsryjnrsyyTHasdasWRTHWRTHWTRadsfasadasdf</a:UniqueId>
                    <a:UreticisininAdUnvani>Deneme </a:UreticisininAdUnvani>
                    <a:UretimBeldeId>2448</a:UretimBeldeId>
                    <a:UretimIlId>19</a:UretimIlId>
                    <a:UretimIlceId>517</a:UretimIlceId>
                    <a:UretimSekli>28</a:UretimSekli>
                      <a:YeniKunyeNo>00000000000111111</a:YeniKunyeNo>
                </a:BildirimKayitCevap>
                 
            </Sonuc>
        </BaseResponseMessageOf_ListOf_BildirimKayitCevap>
    </s:Body>
</s:Envelope>
''';
  var topluOlumlu = '''
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
      	<s:Body>
      		<BaseResponseMessageOf_ListOf_BildirimKayitCevap xmlns="http://www.gtb.gov.tr//WebServices">
      			<HataKodlari xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Core.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
      				<a:ErrorModel>
      					<a:HataKodu>1</a:HataKodu>
      					<a:Mesaj>GTBWSRV0000001</a:Mesaj>
      				</a:ErrorModel>
      			</HataKodlari>
      			<IslemKodu>GTBWSRV0000001</IslemKodu>
      			<Sonuc xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
      				<a:BildirimKayitCevap>
      					<a:AracPlakaNo>06LIT14</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-09T22:10:55.2810057+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1337</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>10</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>2.2</a:RusumMiktari>
      					<a:UniqueId>fe1bb810-1816-11ed-8c25-2dcd831a0833</a:UniqueId>
      					<a:UreticisininAdUnvani i:nil="true"/>
      					<a:UretimBeldeId>5344</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016305007</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
      				<a:BildirimKayitCevap>
      					<a:AracPlakaNo>06LIT14</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-09T22:10:55.4528946+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1337</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>10</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>2.2</a:RusumMiktari>
      					<a:UniqueId>fe1c7b60-1816-11ed-a188-3fa2c9f12f14</a:UniqueId>
      					<a:UreticisininAdUnvani i:nil="true"/>
      					<a:UretimBeldeId>5344</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016305009</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
      			</Sonuc>
      		</BaseResponseMessageOf_ListOf_BildirimKayitCevap>
      	</s:Body>
      </s:Envelope>
''';
  var getCokluBildirimKayitCevapGuncelOlumlu =
      ''' <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
      	<s:Body>
      		<BaseResponseMessageOf_ListOf_BildirimKayitCevap xmlns="http://www.gtb.gov.tr//WebServices">
      			<HataKodlari xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Core.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
      				<a:ErrorModel>
      					<a:HataKodu>1</a:HataKodu>
      					<a:Mesaj>GTBWSRV0000001</a:Mesaj>
      				</a:ErrorModel>
      			</HataKodlari>
      			<IslemKodu>GTBWSRV0000001</IslemKodu>
      			<Sonuc xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
      				<a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.6470285+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1280</a:MalinCinsiId>
      					<a:MalinKodNo>320</a:MalinKodNo>
      					<a:MalinMiktari>1000</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>20</a:RusumMiktari>
      					<a:UniqueId>527b2820-1649-11ed-844c-1bac4b7e6ac3</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073209220016110780</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
      				<a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1352</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>5000</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110781</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
              <a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1796</a:MalinCinsiId>
      					<a:MalinKodNo>423</a:MalinKodNo>
      					<a:MalinMiktari>2000</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110782</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
              <a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1286</a:MalinCinsiId>
      					<a:MalinKodNo>322</a:MalinKodNo>
      					<a:MalinMiktari>2000</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110783</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
              <a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1532</a:MalinCinsiId>
      					<a:MalinKodNo>322</a:MalinKodNo>
      					<a:MalinMiktari>1000</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110784</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
      			</Sonuc>
      		</BaseResponseMessageOf_ListOf_BildirimKayitCevap>
      	</s:Body>
      </s:Envelope>''';
  var getCokluDomatesDomatesOlumlu =
      ''' <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
      	<s:Body>
      		<BaseResponseMessageOf_ListOf_BildirimKayitCevap xmlns="http://www.gtb.gov.tr//WebServices">
      			<HataKodlari xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Core.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
      				<a:ErrorModel>
      					<a:HataKodu>1</a:HataKodu>
      					<a:Mesaj>GTBWSRV0000001</a:Mesaj>
      				</a:ErrorModel>
      			</HataKodlari>
      			<IslemKodu>GTBWSRV0000001</IslemKodu>
      			<Sonuc xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
      				<a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1352</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>5000</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110781</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
              <a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1352</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>5000</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110782</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
              <a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1286</a:MalinCinsiId>
      					<a:MalinKodNo>322</a:MalinKodNo>
      					<a:MalinMiktari>1000</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110784</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
      			</Sonuc>
      		</BaseResponseMessageOf_ListOf_BildirimKayitCevap>
      	</s:Body>
      </s:Envelope>''';
  var get5CokluDomatesDomatesOlumlu =
      ''' <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
      	<s:Body>
      		<BaseResponseMessageOf_ListOf_BildirimKayitCevap xmlns="http://www.gtb.gov.tr//WebServices">
      			<HataKodlari xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Core.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
      				<a:ErrorModel>
      					<a:HataKodu>1</a:HataKodu>
      					<a:Mesaj>GTBWSRV0000001</a:Mesaj>
      				</a:ErrorModel>
      			</HataKodlari>
      			<IslemKodu>GTBWSRV0000001</IslemKodu>
      			<Sonuc xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
      				<a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1352</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>100</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110781</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
              <a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1352</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>50</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110782</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
                <a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1352</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>75</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110783</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>  <a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1352</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>65</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110784</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>  <a:BildirimKayitCevap>
      					<a:AracPlakaNo>34HKS06</a:AracPlakaNo>
      					<a:BelgeNo>0</a:BelgeNo>
      					<a:BelgeTipi>207</a:BelgeTipi>
      					<a:HataKodu>0</a:HataKodu>
      					<a:KayitTarihi>2022-08-07T15:06:08.7722816+03:00</a:KayitTarihi>
      					<a:MalinCinsiId>1352</a:MalinCinsiId>
      					<a:MalinKodNo>335</a:MalinKodNo>
      					<a:MalinMiktari>10</a:MalinMiktari>
      					<a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ</a:MalinSahibAdi>
      					<a:Mesaj i:nil="true"/>
      					<a:MiktarBirimId>74</a:MiktarBirimId>
      					<a:RusumMiktari>16</a:RusumMiktari>
      					<a:UniqueId>527bc460-1649-11ed-91dd-7197b4b49594</a:UniqueId>
      					<a:UreticisininAdUnvani>HAYATİ DÖNMEZ</a:UreticisininAdUnvani>
      					<a:UretimBeldeId>3565</a:UretimBeldeId>
      					<a:UretimIlId>7</a:UretimIlId>
      					<a:UretimIlceId>744</a:UretimIlceId>
      					<a:UretimSekli>28</a:UretimSekli>
      					<a:YeniKunyeNo>1073359220016110785</a:YeniKunyeNo>
      				</a:BildirimKayitCevap>
      			</Sonuc>
      		</BaseResponseMessageOf_ListOf_BildirimKayitCevap>
      	</s:Body>
      </s:Envelope>''';
  String get getCokluBildirimKayitCevapBirOlumluBirOlumsuz => '''
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <BaseResponseMessageOf_ListOf_BildirimKayitCevap xmlns="http://www.gtb.gov.tr//WebServices">
            <HataKodlari xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Core.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
                <a:ErrorModel>
                    <a:HataKodu>1</a:HataKodu>
                    <a:Mesaj>GTBWSRV0000001</a:Mesaj>
                </a:ErrorModel>
            </HataKodlari>
            <IslemKodu>GTBWSRV0000001</IslemKodu>
            <Sonuc xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
                <a:BildirimKayitCevap>
                    <a:AracPlakaNo i:nil="true"/>
                    <a:BelgeNo i:nil="true"/>
                    <a:BelgeTipi>0</a:BelgeTipi>
                    <a:HataKodu>156</a:HataKodu>
                    <a:KayitTarihi>0001-01-01T00:00:00</a:KayitTarihi>
                    <a:MalinCinsiId>0</a:MalinCinsiId>
                    <a:MalinKodNo>0</a:MalinKodNo>
                    <a:MalinMiktari>0</a:MalinMiktari>
                    <a:MalinSahibAdi i:nil="true"/>
                    <a:Mesaj>Ürün cinsi bilgisi yanlış. Ürün no : "319", Ürün cinsi no : "1352"</a:Mesaj>
                    <a:MiktarBirimId>0</a:MiktarBirimId>
                    <a:RusumMiktari>0</a:RusumMiktari>
                    <a:UniqueId>asdfasgaADRGRGQEHWEQTHWRTHWRTHWTRadsfasf</a:UniqueId>
                    <a:UreticisininAdUnvani i:nil="true"/>
                    <a:UretimBeldeId>0</a:UretimBeldeId>
                    <a:UretimIlId>0</a:UretimIlId>
                    <a:UretimIlceId>0</a:UretimIlceId>
                    <a:UretimSekli>0</a:UretimSekli>
                    <a:YeniKunyeNo>0</a:YeniKunyeNo>
                </a:BildirimKayitCevap>
                <a:BildirimKayitCevap>
                    <a:AracPlakaNo>06LIT14</a:AracPlakaNo>
                    <a:BelgeNo>0</a:BelgeNo>
                    <a:BelgeTipi>207</a:BelgeTipi>
                    <a:HataKodu>0</a:HataKodu>
                    <a:KayitTarihi>2022-08-03T22:43:01.1768333+03:00</a:KayitTarihi>
                    <a:MalinCinsiId>1328</a:MalinCinsiId>
                    <a:MalinKodNo>335</a:MalinKodNo>
                    <a:MalinMiktari>100</a:MalinMiktari>
                    <a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ </a:MalinSahibAdi>
                    <a:Mesaj i:nil="true"/>
                    <a:MiktarBirimId>74</a:MiktarBirimId>
                    <a:RusumMiktari>20</a:RusumMiktari>
                    <a:UniqueId>asdfasgaADRGRGQEHWEQTHWRTHWRTHWTRadsfasadasdf</a:UniqueId>
                    <a:UreticisininAdUnvani>HTICE NAZ</a:UreticisininAdUnvani>
                    <a:UretimBeldeId>3646</a:UretimBeldeId>
                    <a:UretimIlId>15</a:UretimIlId>
                    <a:UretimIlceId>769</a:UretimIlceId>
                    <a:UretimSekli>28</a:UretimSekli>
                    <a:YeniKunyeNo>1153359220015862622</a:YeniKunyeNo>
                </a:BildirimKayitCevap>
            </Sonuc>
        </BaseResponseMessageOf_ListOf_BildirimKayitCevap>
    </s:Body>
</s:Envelope>
''';
  String get getCokluBildirimKayitCevapBirOlumluBirOlumsuz2 => '''
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <BaseResponseMessageOf_ListOf_BildirimKayitCevap xmlns="http://www.gtb.gov.tr//WebServices">
            <HataKodlari xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Core.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
                <a:ErrorModel>
                    <a:HataKodu>2</a:HataKodu>
                    <a:Mesaj>GTBWSRV0000002</a:Mesaj>
                </a:ErrorModel>
            </HataKodlari>
            <IslemKodu>GTBWSRV0000002</IslemKodu>
            <Sonuc xmlns:a="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
                <a:BildirimKayitCevap>
                    <a:AracPlakaNo>06LIT14</a:AracPlakaNo>
                    <a:BelgeNo>0</a:BelgeNo>
                    <a:BelgeTipi>207</a:BelgeTipi>
                    <a:HataKodu>0</a:HataKodu>
                    <a:KayitTarihi>2022-08-03T22:44:41.2421543+03:00</a:KayitTarihi>
                    <a:MalinCinsiId>1256</a:MalinCinsiId>
                    <a:MalinKodNo>319</a:MalinKodNo>
                    <a:MalinMiktari>100</a:MalinMiktari>
                    <a:MalinSahibAdi>UMUT 14 TARIM ÜRÜNLERİ GIDA NAKLİYAT İNŞAAT TURİZM SANAYİ VE TİCARET LİMİTED ŞİRKETİ </a:MalinSahibAdi>
                    <a:Mesaj i:nil="true"/>
                    <a:MiktarBirimId>74</a:MiktarBirimId>
                    <a:RusumMiktari>16</a:RusumMiktari>
                    <a:UniqueId>asdfasgaADRGRGQEHWEQTHWRTHWRTHWTRadsfasf</a:UniqueId>
                    <a:UreticisininAdUnvani>HTICE NAZ</a:UreticisininAdUnvani>
                    <a:UretimBeldeId>3646</a:UretimBeldeId>
                    <a:UretimIlId>15</a:UretimIlId>
                    <a:UretimIlceId>769</a:UretimIlceId>
                    <a:UretimSekli>28</a:UretimSekli>
                    <a:YeniKunyeNo>1153199220015862683</a:YeniKunyeNo>
                </a:BildirimKayitCevap>
                <a:BildirimKayitCevap>
                    <a:AracPlakaNo i:nil="true"/>
                    <a:BelgeNo i:nil="true"/>
                    <a:BelgeTipi>0</a:BelgeTipi>
                    <a:HataKodu>22</a:HataKodu>
                    <a:KayitTarihi>0001-01-01T00:00:00</a:KayitTarihi>
                    <a:MalinCinsiId>0</a:MalinCinsiId>
                    <a:MalinKodNo>0</a:MalinKodNo>
                    <a:MalinMiktari>0</a:MalinMiktari>
                    <a:MalinSahibAdi i:nil="true"/>
                    <a:Mesaj>UniqueId alanı asdfasgaADRGRGQEHWEQTHWRTHWRTHWTRadsfasadasdf, 33945 Id li kisi için tekil değil. Kullanıldığı künyeler (1153359220015862622) </a:Mesaj>
                    <a:MiktarBirimId>0</a:MiktarBirimId>
                    <a:RusumMiktari>0</a:RusumMiktari>
                    <a:UniqueId>asdfasgaADRGRGQEHWEQTHWRTHWRTHWTRadsfasadasdf</a:UniqueId>
                    <a:UreticisininAdUnvani i:nil="true"/>
                    <a:UretimBeldeId>0</a:UretimBeldeId>
                    <a:UretimIlId>0</a:UretimIlId>
                    <a:UretimIlceId>0</a:UretimIlceId>
                    <a:UretimSekli>0</a:UretimSekli>
                    <a:YeniKunyeNo>0</a:YeniKunyeNo>
                </a:BildirimKayitCevap>
            </Sonuc>
        </BaseResponseMessageOf_ListOf_BildirimKayitCevap>
    </s:Body>
</s:Envelope>
''';
}
