import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateAuthorizationString(String url, String data, String apiKey,
    String secretKey, String randomKey) {
  var startIndex = url.indexOf("/v2");
  var endIndex = url.contains("?") ? url.indexOf("?") : url.length;
  var uriPath = url.substring(startIndex, endIndex);

  var payload = uriPath + (data.isEmpty ? "" : data);
  print(data.isEmpty);
  print(data);
  var dataToEncrypt = randomKey + payload;

  var key = utf8.encode(secretKey);
  var bytes = utf8.encode(dataToEncrypt);

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);

  var authorizationString =
      "apiKey:$apiKey&randomKey:$randomKey&signature:$digest";

  var bytesAuthorization = utf8.encode(authorizationString);
  var base64EncodedAuthorization = base64.encode(bytesAuthorization);
  return "IYZWSv2 $base64EncodedAuthorization";
}
