import 'dart:convert';

import 'package:hal_app/core/model/error_model/base_error_model.dart';
import 'package:hal_app/core/model/response_model/response_model.dart';
import 'package:hal_app/feature/helper/active_tc.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

import '../../../../core/model/response_model/IResponse_model.dart';
import 'fatura_extension/attackment_content_xml.dart';

class IzibizFaturaService {
  static IzibizFaturaService? _instance;
  static IzibizFaturaService get instance =>
      _instance ?? IzibizFaturaService._();

  IzibizFaturaService._();
  Future<IResponseModel<String?>> sendIrsaliyeIzibiz(String sessionId) async {
    String uuid = _uniqueIdGenerator;

    List<int> bytes =
        utf8.encode(_fixIncomingIndexForIrasliye(UUID: uuid, ID: "ID"));
    String newContent = base64Encode(bytes);

    String requestBody = _mainXmlGeneratorForMustahsil(newContent,
        sessionId: sessionId, ID: "ID", UUID: uuid);
    var result = await http.post(
        Uri.parse(
            "https://efaturatest.izibiz.com.tr:443/CreditNoteWS/CreditNote"),
        body: '''''',
        headers: {"Content-Type": "text/xml; charset=utf-8"});


    return ResponseModel();
  }

  Future<IResponseModel<String?>> sendMustahsilIzibiz(String sessionId) async {
    String uuid = _uniqueIdGenerator;
    List<int> bytes = utf8.encode(
        _fixIncomingIndexForMustahsil(UUID: uuid, ID: "ABC2009123456781"));
    String newContent = base64Encode(bytes);

    String requestBody = _mainXmlGeneratorForMustahsil(newContent,
        sessionId: sessionId, ID: "ABC2009123456781", UUID: uuid);
    var result = await http.post(
        Uri.parse(
            "https://efaturatest.izibiz.com.tr:443/CreditNoteWS/CreditNote"),
        body: requestBody,
        headers: {"Content-Type": "text/xml; charset=utf-8"});

    return ResponseModel();
  }

  String get _uniqueIdGenerator {
    var uuid = Uuid();
    return uuid.v1();
  }

  String _mainXmlGeneratorForIrsaliye(String content, //IRS2022994235438
      {required String sessionId,
      required String ID,
      required String UUID}) {
    return '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl" xmlns:xmime="http://www.w3.org/2005/05/xmlmime">
    <soapenv:Header/>
    <soapenv:Body>
        <wsdl:SendDespatchAdviceRequest>
            <REQUEST_HEADER>
                <SESSION_ID>$UUID</SESSION_ID>
                <COMPRESSED>N</COMPRESSED>
            </REQUEST_HEADER>defaultpk@izibiz.com.tr
            <SENDER vkn="${ActiveTc.instance.activeTc}" alias="urn:mail:defaultgb@izibiz.com.tr"/>
            <RECEIVER vkn="${ActiveTc.instance.activeTc}" alias="urn:mail:defaultpk@izibiz.com.tr"/>
            <DESPATCHADVICE ID="$ID" UUID="$UUID" DIRECTION="">
                <DESPATCHADVICEHEADER>
            </DESPATCHADVICEHEADER>
                <RECEIPTADVICEHEADER>
            </RECEIPTADVICEHEADER>
                <CONTENT xmime:contentType="application/?">$content</CONTENT>
            </DESPATCHADVICE>
            <DESPATCHADVICE_PROPERTIES>
                <EMAIL_FLAG>N</EMAIL_FLAG>
                <EMAIL>irsaliyepk@gib.gov.tr</EMAIL>
            </DESPATCHADVICE_PROPERTIES>
        </wsdl:SendDespatchAdviceRequest>
    </soapenv:Body>
</soapenv:Envelope>''';
  }

  String _mainXmlGeneratorForMustahsil(String content,
      {required String sessionId, required String ID, required String UUID}) {
    return '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl" xmlns:xmime="http://www.w3.org/2005/05/xmlmime">
    <soapenv:Header/>
    <soapenv:Body>
        <wsdl:SendCreditNoteRequest>
            <REQUEST_HEADER>
            <SESSION_ID>$sessionId</SESSION_ID>
                <COMPRESSED>N</COMPRESSED>
            </REQUEST_HEADER>
            <CREDITNOTE ID="$ID" UUID="$UUID">
                <HEADER>
                </HEADER>
                <CONTENT xmime:contentType="application/?">$content
                </CONTENT>
            </CREDITNOTE>
            <CREDITNOTE_PROPERTIES>
                <SMS_FLAG>N</SMS_FLAG>
                <EMAIL_FLAG>N</EMAIL_FLAG>
                <SENDING_TYPE>KAGIT</SENDING_TYPE>
            </CREDITNOTE_PROPERTIES>
            <SERIES_PROPERTIES>
                <SERIES_FLAG>N</SERIES_FLAG>  
            </SERIES_PROPERTIES>
        </wsdl:SendCreditNoteRequest>
    </soapenv:Body>
</soapenv:Envelope>
''';
  }

  String _fixIncomingIndexForIrasliye(
      {required String UUID, required String ID}) {
    return '''
<DespatchAdvice xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:n4="http://www.altova.com/samplexml/other-namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2 ../xsdrt/maindoc/UBL-DespatchAdvice-2.1.xsd" xmlns="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2">
	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>
	<cbc:CustomizationID>TR1.2</cbc:CustomizationID>
	<cbc:ProfileID>TEMELIRSALIYE</cbc:ProfileID>
	<cbc:ID>IRS2022994235439</cbc:ID>
	<cbc:CopyIndicator>false</cbc:CopyIndicator>
	<cbc:UUID>249508c7-f8f1-4da0-9943-ca6facd4e5db</cbc:UUID>
	<cbc:IssueDate>2022-09-06</cbc:IssueDate>
	<cbc:IssueTime>12:04:14.0000000+05:30</cbc:IssueTime>
	<cbc:DespatchAdviceTypeCode>SEVK</cbc:DespatchAdviceTypeCode>
	<cbc:Note>Denemedir</cbc:Note>
	<cbc:LineCountNumeric>1</cbc:LineCountNumeric>
	<cac:AdditionalDocumentReference>
		<cbc:ID>3883a6c4-9b4c-419e-9aa5-f6abf1b82ef6</cbc:ID>
		<cbc:IssueDate>2022-09-06</cbc:IssueDate>
		<cbc:DocumentType>XSLT</cbc:DocumentType>
		<cac:Attachment>
			<cbc:EmbeddedDocumentBinaryObject mimeCode="application/xml" encodingCode="Base64" characterSetCode="UTF-8" filename="IRS2022994235438.xslt">${AttachmentContentXml.instance.attachmentContentXmlForIrasaliye}</cbc:EmbeddedDocumentBinaryObject>
		</cac:Attachment>
	</cac:AdditionalDocumentReference>
	<cac:Signature>
		<cbc:ID schemeID="VKN_TCKN">4840847211</cbc:ID>
		<cac:SignatoryParty>
			<cbc:WebsiteURI>https://www.izibiz.com.tr</cbc:WebsiteURI>
			<cac:PartyIdentification>
				<cbc:ID schemeID="VKN">4840847211</cbc:ID>
			</cac:PartyIdentification>
			<cac:PartyName>
				<cbc:Name>Alliance One Technologies</cbc:Name>
			</cac:PartyName>
			<cac:PostalAddress>
				<cbc:StreetName>Yıldız Teknik üniversitesi Teknopark B Blok Kat:2 No:412 Davutpaşa -Esenler /İstanbul</cbc:StreetName>
				<cbc:CitySubdivisionName>ATABEY</cbc:CitySubdivisionName>
				<cbc:CityName>İSTANBUL</cbc:CityName>
				<cbc:PostalZone>34521</cbc:PostalZone>
				<cac:Country>
					<cbc:Name>Turkey</cbc:Name>
				</cac:Country>
			</cac:PostalAddress>
			<cac:PartyTaxScheme>
				<cac:TaxScheme>
					<cbc:Name>DAVUTPAŞA</cbc:Name>
				</cac:TaxScheme>
			</cac:PartyTaxScheme>
			<cac:Contact>
				<cbc:Telephone>2122121212</cbc:Telephone>
				<cbc:Telefax>21211111111</cbc:Telefax>
				<cbc:ElectronicMail>defaultgb@izibiz.com.tr</cbc:ElectronicMail>
			</cac:Contact>
		</cac:SignatoryParty>
		<cac:DigitalSignatureAttachment>
			<cac:ExternalReference>
				<cbc:URI>#Signature_UblDespatch.IDType</cbc:URI>
			</cac:ExternalReference>
		</cac:DigitalSignatureAttachment>
	</cac:Signature>
	<cac:DespatchSupplierParty>
		<cac:Party>
			<cbc:WebsiteURI>https://www.izibiz.com.tr</cbc:WebsiteURI>
			<cac:PartyIdentification>
				<cbc:ID schemeID="VKN">4840847211</cbc:ID>
			</cac:PartyIdentification>
			<cac:PartyName>
				<cbc:Name>Alliance One Technologies1 AŞ</cbc:Name>
			</cac:PartyName>
			<cac:PostalAddress>
				<cbc:StreetName>Yıldız Teknik üniversitesi Teknopark B Blok Kat:2 No:412 Davutpaşa -Esenler /İstanbul</cbc:StreetName>
				<cbc:CitySubdivisionName>ATABEY</cbc:CitySubdivisionName>
				<cbc:CityName>İSTANBUL</cbc:CityName>
				<cbc:PostalZone>34521</cbc:PostalZone>
				<cac:Country>
					<cbc:Name>Turkey</cbc:Name>
				</cac:Country>
			</cac:PostalAddress>
			<cac:PartyTaxScheme>
				<cac:TaxScheme>
					<cbc:Name>DAVUTPAŞA</cbc:Name>
				</cac:TaxScheme>
			</cac:PartyTaxScheme>
			<cac:Contact>
				<cbc:Telephone>2122121212</cbc:Telephone>
				<cbc:Telefax>2121111111</cbc:Telefax>
				<cbc:ElectronicMail>defaultgb@izibiz.com.tr</cbc:ElectronicMail>
			</cac:Contact>
		</cac:Party>
		<cac:DespatchContact>
			<cbc:Name/>
		</cac:DespatchContact>
	</cac:DespatchSupplierParty>
	<cac:DeliveryCustomerParty>
		<cac:Party>
			<cbc:WebsiteURI>https://www.izibiz.com.tr</cbc:WebsiteURI>
			<cac:PartyIdentification>
				<cbc:ID schemeID="VKN">4840847211</cbc:ID>
			</cac:PartyIdentification>
			<cac:PartyName>
				<cbc:Name>Alliance One Technologies2 AŞ</cbc:Name>
			</cac:PartyName>
			<cac:PostalAddress>
				<cbc:StreetName>Yıldız Teknik üniversitesi Teknopark B Blok Kat:2 No:412 Davutpaşa -Esenler /İstanbul</cbc:StreetName>
				<cbc:CitySubdivisionName>ATABEY</cbc:CitySubdivisionName>
				<cbc:CityName>İSTANBUL</cbc:CityName>
				<cbc:PostalZone>34521</cbc:PostalZone>
				<cac:Country>
					<cbc:Name>Turkey</cbc:Name>
				</cac:Country>
			</cac:PostalAddress>
			<cac:PartyTaxScheme>
				<cac:TaxScheme>
					<cbc:Name>DAVUTPAŞA</cbc:Name>
				</cac:TaxScheme>
			</cac:PartyTaxScheme>
			<cac:Contact>
				<cbc:Telephone>2122121212</cbc:Telephone>
				<cbc:Telefax>2122221111</cbc:Telefax>
				<cbc:ElectronicMail>defaultgb@izibiz.com.tr</cbc:ElectronicMail>
			</cac:Contact>
		</cac:Party>
	</cac:DeliveryCustomerParty>
	<cac:Shipment>
		<cbc:ID/>
		<cbc:NetWeightMeasure unitCode="C62">50.0</cbc:NetWeightMeasure>
		<cbc:TotalGoodsItemQuantity>1.0</cbc:TotalGoodsItemQuantity>
		<cac:GoodsItem>
			<cbc:ValueAmount currencyID="TRY">8000.0</cbc:ValueAmount>
		</cac:GoodsItem>
		<cac:ShipmentStage>
			<cbc:ID>1</cbc:ID>
			<cbc:TransportModeCode/>
			<cac:TransportMeans>
				<cac:RoadTransport>
					<cbc:LicensePlateID schemeID="PLAKA">34FB69</cbc:LicensePlateID>
				</cac:RoadTransport>
			</cac:TransportMeans>
			<cac:DriverPerson>
				<cbc:FirstName>DEMET</cbc:FirstName>
				<cbc:FamilyName>DERE</cbc:FamilyName>
				<cbc:NationalityID>11111111111</cbc:NationalityID>
			</cac:DriverPerson>
		</cac:ShipmentStage>
		<cac:Delivery>
			<cac:DeliveryAddress>
				<cbc:CitySubdivisionName>info@bicycleworld.com</cbc:CitySubdivisionName>
				<cbc:CityName>ISTANBUL</cbc:CityName>
				<cbc:PostalZone>34065</cbc:PostalZone>
				<cac:Country>
					<cbc:Name>TURKIYE</cbc:Name>
				</cac:Country>
			</cac:DeliveryAddress>
			<cac:CarrierParty>
				<cbc:WebsiteURI>https://www.izibiz.com.tr</cbc:WebsiteURI>
				<cac:PartyIdentification>
					<cbc:ID schemeID="VKN">4840847211</cbc:ID>
				</cac:PartyIdentification>
				<cac:PartyName>
					<cbc:Name>Alliance One Technologies3 AŞ</cbc:Name>
				</cac:PartyName>
				<cac:PostalAddress>
					<cbc:StreetName>Yıldız Teknik üniversitesi Teknopark B Blok Kat:2 No:412 Davutpaşa -Esenler /İstanbul</cbc:StreetName>
					<cbc:CitySubdivisionName>ATABEY</cbc:CitySubdivisionName>
					<cbc:CityName>ISTANBUL</cbc:CityName>
					<cbc:PostalZone>34521</cbc:PostalZone>
					<cac:Country>
						<cbc:Name>Turkey</cbc:Name>
					</cac:Country>
				</cac:PostalAddress>
				<cac:PartyTaxScheme>
					<cac:TaxScheme>
						<cbc:Name>DAVUTPAŞA</cbc:Name>
					</cac:TaxScheme>
				</cac:PartyTaxScheme>
				<cac:Contact>
					<cbc:Telephone>2122121212</cbc:Telephone>
					<cbc:Telefax>2122221111</cbc:Telefax>
					<cbc:ElectronicMail>defaultgb@izibiz.com.tr</cbc:ElectronicMail>
				</cac:Contact>
			</cac:CarrierParty>
			<cac:Despatch>
				<cbc:ActualDespatchDate>2022-09-06</cbc:ActualDespatchDate>
				<cbc:ActualDespatchTime>12:04:14.0000000+05:30</cbc:ActualDespatchTime>
			</cac:Despatch>
		</cac:Delivery>
	</cac:Shipment>
	<cac:DespatchLine>
		<cbc:ID>1</cbc:ID>
		<cbc:DeliveredQuantity unitCode="C62">1.0</cbc:DeliveredQuantity>
		<cac:OrderLineReference>
			<cbc:LineID/>
		</cac:OrderLineReference>
		<cac:Item>
			<cbc:Name>Laptop</cbc:Name>
			<cac:SellersItemIdentification>
				<cbc:ID>BP0001</cbc:ID>
			</cac:SellersItemIdentification>
		</cac:Item>
		<cac:Shipment>
			<cbc:ID/>
			<cac:GoodsItem>
				<cac:InvoiceLine>
					<cbc:ID/>
					<cbc:InvoicedQuantity unitCode="C62">0</cbc:InvoicedQuantity>
					<cbc:LineExtensionAmount currencyID="TRY">8000.0</cbc:LineExtensionAmount>
					<cac:Item>
						<cbc:Name>BP0001</cbc:Name>
					</cac:Item>
					<cac:Price>
						<cbc:PriceAmount currencyID="TRY">8000.0</cbc:PriceAmount>
					</cac:Price>
				</cac:InvoiceLine>
			</cac:GoodsItem>
		</cac:Shipment>
	</cac:DespatchLine>
</DespatchAdvice>

''';
  }

  String _fixIncomingIndexForMustahsil(
      {required String UUID, required String ID}) {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
<ns4:CreditNote xmlns:ns4="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:ns2="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:ns3="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2">
	<ext:UBLExtensions>
		<ext:UBLExtension>
			<ext:ExtensionContent>
			</ext:ExtensionContent>
		</ext:UBLExtension>
	</ext:UBLExtensions>
	<ns2:UBLVersionID>2.1</ns2:UBLVersionID>
	<ns2:CustomizationID>TR1.2</ns2:CustomizationID>
	<ns2:ProfileID>EARSIVBELGE</ns2:ProfileID>
	<ns2:ID>$ID</ns2:ID>
	<ns2:CopyIndicator>false</ns2:CopyIndicator>
	<ns2:UUID>$UUID</ns2:UUID>
	<ns2:IssueDate>2022-04-21+03:00</ns2:IssueDate>
	<ns2:IssueTime>13:49:56.890+03:00</ns2:IssueTime>
	<ns2:CreditNoteTypeCode>MUSTAHSILMAKBUZ</ns2:CreditNoteTypeCode>
	<ns2:Note>Yalnız yirmiDört TL Elli kuruş.</ns2:Note>
	<ns2:Note>Bilgi: e-Müstahsil izni kapsamında oluşturulmuştur.</ns2:Note>
	<ns2:DocumentCurrencyCode>TRY</ns2:DocumentCurrencyCode>
	<ns2:LineCountNumeric>1</ns2:LineCountNumeric>
	<ns3:AdditionalDocumentReference>
		<ns2:ID>FKL2022000000001</ns2:ID>
		<ns2:IssueDate>2022-04-21+03:00</ns2:IssueDate>
		<ns2:DocumentType>XSLT</ns2:DocumentType>
		<ns3:Attachment>
			<ns2:EmbeddedDocumentBinaryObject characterSetCode="UTF-8" encodingCode="base64" filename="FKL2022000000001.xslt" mimeCode="application/xml">${AttachmentContentXml.instance.attachmentContentXmlForMustahsil}</ns2:EmbeddedDocumentBinaryObject>
		</ns3:Attachment>
	</ns3:AdditionalDocumentReference>
	<ns3:Signature>
		<ns2:ID schemeID="VKN_TCKN">${ActiveTc.instance.activeTc}</ns2:ID>
		<ns3:SignatoryParty>
			<ns2:WebsiteURI>https://www.izibiz.com.tr</ns2:WebsiteURI>
			<ns3:PartyIdentification>
				<ns2:ID schemeID="VKN">${ActiveTc.instance.activeTc}</ns2:ID>
			</ns3:PartyIdentification>
			<ns3:PartyName>
				<ns2:Name>akbil teknolojileri</ns2:Name>
			</ns3:PartyName>
			<ns3:PostalAddress>
				<ns2:StreetName>DENEME ADRES BİLGİLERİ</ns2:StreetName>
				<ns2:CitySubdivisionName>KAHRAMANKAZAN</ns2:CitySubdivisionName>
				<ns2:CityName>ANKARA</ns2:CityName>
				<ns2:PostalZone/>
				<ns3:Country>
					<ns2:Name>TÜRKİYE</ns2:Name>
				</ns3:Country>
			</ns3:PostalAddress>
			<ns3:PartyTaxScheme>
				<ns3:TaxScheme>
					<ns2:Name>KURUMLAR</ns2:Name>
				</ns3:TaxScheme>
			</ns3:PartyTaxScheme>
			<ns3:Contact>
				<ns2:Telephone>(800) 811-1199</ns2:Telephone>
				<ns2:Telefax/>
				<ns2:ElectronicMail>yazilim@izibiz.com.tr</ns2:ElectronicMail>
			</ns3:Contact>
		</ns3:SignatoryParty>
		<ns3:DigitalSignatureAttachment>
			<ns3:ExternalReference>
				<ns2:URI>#Signature_FKL2022000000001</ns2:URI>
			</ns3:ExternalReference>
		</ns3:DigitalSignatureAttachment>
	</ns3:Signature>
	<ns3:AccountingSupplierParty>
		<ns3:Party>
			<ns2:WebsiteURI>https://www.izibiz.com.tr</ns2:WebsiteURI>
			<ns3:PartyIdentification>
				<ns2:ID schemeID="VKN">4840847211</ns2:ID>
			</ns3:PartyIdentification>
			<ns3:PartyName>
				<ns2:Name>İZİBİZ BİLİŞİM TEKNOLOJİLERİ AŞ</ns2:Name>
			</ns3:PartyName>
			<ns3:PostalAddress>
				<ns2:StreetName>Esenler</ns2:StreetName>
				<ns2:CitySubdivisionName>Esenler</ns2:CitySubdivisionName>
				<ns2:CityName>İstanbul</ns2:CityName>
				<ns2:PostalZone>34065</ns2:PostalZone>
				<ns3:Country>
					<ns2:Name>Türkiye</ns2:Name>
				</ns3:Country>
			</ns3:PostalAddress>
			<ns3:PartyTaxScheme>
				<ns3:TaxScheme>
					<ns2:Name>DAVUTPAŞA</ns2:Name>
				</ns3:TaxScheme>
			</ns3:PartyTaxScheme>
			<ns3:Contact>
				<ns2:Telephone>11111111111</ns2:Telephone>
				<ns2:Telefax>11111111111</ns2:Telefax>
				<ns2:ElectronicMail>email@example.com</ns2:ElectronicMail>
			</ns3:Contact>
		</ns3:Party>
	</ns3:AccountingSupplierParty>
	<ns3:AccountingCustomerParty>7777--
		<ns3:Party>
			<ns2:WebsiteURI>https://www.izibiz.com.tr</ns2:WebsiteURI>
			<ns3:PartyIdentification>
				<ns2:ID schemeID="VKN">4840847211</ns2:ID>
			</ns3:PartyIdentification>
			<ns3:PartyName>
				<ns2:Name>İZİBİZ BİLİŞİM TEKNOLOJİLERİ AŞ</ns2:Name>
			</ns3:PartyName>
			<ns3:PostalAddress>
				<ns2:StreetName>Esenler</ns2:StreetName>
				<ns2:CitySubdivisionName>Esenler</ns2:CitySubdivisionName>
				<ns2:CityName>İstanbul</ns2:CityName>
				<ns2:PostalZone>34065</ns2:PostalZone>
				<ns3:Country>
					<ns2:Name>Türkiye</ns2:Name>
				</ns3:Country>
			</ns3:PostalAddress>
			<ns3:PartyTaxScheme>
				<ns3:TaxScheme>
					<ns2:Name>DAVUTPAŞA</ns2:Name>
				</ns3:TaxScheme>
			</ns3:PartyTaxScheme>
			<ns3:Contact>
				<ns2:Telephone>11111111111</ns2:Telephone>
				<ns2:Telefax>11111111111</ns2:Telefax>
				<ns2:ElectronicMail>email@example.com</ns2:ElectronicMail>
			</ns3:Contact>
		</ns3:Party>
	</ns3:AccountingCustomerParty>7777---
	<ns3:Delivery>
		<ns2:ActualDeliveryDate>2022-04-21+03:00</ns2:ActualDeliveryDate>
	</ns3:Delivery>
	<ns3:TaxTotal>777----
		<ns2:TaxAmount currencyID="TRY">0.5</ns2:TaxAmount>
		<ns3:TaxSubtotal>
			<ns2:TaxableAmount currencyID="TRY">25</ns2:TaxableAmount>
			<ns2:TaxAmount currencyID="TRY">0.5</ns2:TaxAmount>
			<ns2:CalculationSequenceNumeric>1</ns2:CalculationSequenceNumeric>
			<ns2:Percent format="%">2</ns2:Percent>
			<ns3:TaxCategory>
				<ns3:TaxScheme>
					<ns2:Name languageLocaleID="bağkur">Bağkur(SGK_PRIM)</ns2:Name>
					<ns2:TaxTypeCode>SGK_PRIM</ns2:TaxTypeCode>
				</ns3:TaxScheme>
			</ns3:TaxCategory>
		</ns3:TaxSubtotal>
	</ns3:TaxTotal>
	<ns3:TaxTotal>
		<ns2:TaxAmount currencyID="TRY">0.5</ns2:TaxAmount>
		<ns3:TaxSubtotal>
			<ns2:TaxableAmount currencyID="TRY">25</ns2:TaxableAmount>
			<ns2:TaxAmount currencyID="TRY">0.5</ns2:TaxAmount>
			<ns2:CalculationSequenceNumeric>1</ns2:CalculationSequenceNumeric>
			<ns2:Percent format="%">2</ns2:Percent>
			<ns3:TaxCategory>
				<ns3:TaxScheme>
					<ns2:Name languageLocaleID="bağkur">Bağkur(SGK_PRIM)</ns2:Name>
					<ns2:TaxTypeCode>SGK_PRIM</ns2:TaxTypeCode>
				</ns3:TaxScheme>
			</ns3:TaxCategory>
		</ns3:TaxSubtotal>
	</ns3:TaxTotal>
	<ns3:LegalMonetaryTotal>
		<ns2:LineExtensionAmount currencyID="TRY">25.0</ns2:LineExtensionAmount>
		<ns2:TaxExclusiveAmount currencyID="TRY">25.0</ns2:TaxExclusiveAmount>
		<ns2:TaxInclusiveAmount currencyID="TRY">24.5</ns2:TaxInclusiveAmount>
		<ns2:AllowanceTotalAmount currencyID="TRY">0.0</ns2:AllowanceTotalAmount>
		<ns2:PayableAmount currencyID="TRY">24.5</ns2:PayableAmount>
	</ns3:LegalMonetaryTotal>
	<ns3:CreditNoteLine>
		<ns2:ID>1</ns2:ID>
		<ns2:Note/>
		<ns2:CreditedQuantity unitCode="C62">1</ns2:CreditedQuantity>
		<ns2:LineExtensionAmount currencyID="TRY">25</ns2:LineExtensionAmount>
		<ns3:OrderLineReference>
			<ns2:LineID>1</ns2:LineID>
		</ns3:OrderLineReference>
		<ns3:TaxTotal>
			<ns2:TaxAmount currencyID="TRY">0.5</ns2:TaxAmount>
			<ns3:TaxSubtotal>
				<ns2:TaxableAmount currencyID="TRY">25</ns2:TaxableAmount>
				<ns2:TaxAmount currencyID="TRY">0.5</ns2:TaxAmount>
				<ns2:CalculationSequenceNumeric>1</ns2:CalculationSequenceNumeric>
				<ns2:Percent format="%">2</ns2:Percent>
				<ns3:TaxCategory>
					<ns3:TaxScheme>
						<ns2:Name languageLocaleID="bağkur">Bağkur(SGK_PRIM)</ns2:Name>
						<ns2:TaxTypeCode>SGK_PRIM</ns2:TaxTypeCode>
					</ns3:TaxScheme>
				</ns3:TaxCategory>
			</ns3:TaxSubtotal>
		</ns3:TaxTotal>
		<ns3:Item>
			<ns2:Name>Müstahsil</ns2:Name>
			<ns3:SellersItemIdentification>
				<ns2:ID>011</ns2:ID>
			</ns3:SellersItemIdentification>
		</ns3:Item>
		<ns3:Price>
			<ns2:PriceAmount currencyID="TRY">25</ns2:PriceAmount>
		</ns3:Price>
	</ns3:CreditNoteLine>
</ns4:CreditNote>''';
  }
}
