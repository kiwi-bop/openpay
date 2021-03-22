import 'dart:convert';

import 'package:http/http.dart';

const _sandboxUrl = 'https://sandbox-api.openpay.mx';
const _prodUrl = 'https://api.openpay.mx';

/// Openpay instance
class Openpay {
  /// enable sandox or production mode
  /// False by default
  final bool isSandboxMode;

  /// Your merchant id
  final String merchantId;

  /// Your public API Key
  final String apiKey;

  Openpay(this.merchantId, this.apiKey, {this.isSandboxMode = false});

  String get _merchantBaseUrl => '$baseUrl/v1/$merchantId';

  String get baseUrl => isSandboxMode ? _sandboxUrl : _prodUrl;

  /// Create a token from card data
  Future<TokenInfo> createToken(CardInfo card) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$apiKey:'));
    Response response = await post(Uri.parse('$_merchantBaseUrl/tokens'), headers: {
      'Content-type': 'application/json',
      'Authorization': basicAuth,
      'Accept': 'application/json',
    }, body: """{
      "card_number": "${card.cardNumber}",
      "holder_name": "${card.holderName}",
      "expiration_year": "${card.expirationYear}",
      "expiration_month": "${card.expirationMonth}",
      "cvv2": "${card.cvv2}"
    }""");

    if (response.statusCode == 201) {
      return TokenInfo._fromBackend(jsonDecode(response.body));
    } else {
      throw Exception('Error ${response.statusCode}, ${response.body}');
    }
  }

}

/// Card data representation class
class CardInfo {
  final String cardNumber;
  final String holderName;
  final String expirationYear;
  final String expirationMonth;
  final String? cvv2;
  final String? brand;
  final String? creationDate;

  CardInfo(this.cardNumber, this.holderName, this.expirationYear, this.expirationMonth, String cvv2)
      : brand = null,
        creationDate = null,
        this.cvv2 = cvv2;

  CardInfo._({
    required this.cardNumber,
    required this.holderName,
    required this.expirationYear,
    required this.expirationMonth,
    this.cvv2,
    this.brand,
    this.creationDate,
  });

  factory CardInfo._fromBackend(Map data) {
    return CardInfo._(
      cardNumber: data['card_number'],
      holderName: data['holder_name'],
      expirationYear: data['expiration_year'],
      expirationMonth: data['expiration_month'],
      cvv2: data['cvv2'],//never returned by backend :)
      brand: data['brand'],
      creationDate: data['creationDate'],
    );
  }

  @override
  String toString() {
    return 'CardInfo{cardNumber: ${cardNumber.contains('XX') ? cardNumber : 'hidden'}, holderName: $holderName, expirationYear: $expirationYear, expirationMonth: $expirationMonth, cvv2: ${cvv2 == null ? null : '***'}, brand: $brand, creationDate: $creationDate}';
  }
}

/// Token data representation class
/// You need to use id as token
class TokenInfo {
  final String id;
  final CardInfo card;

  TokenInfo._(this.id, this.card);

  factory TokenInfo._fromBackend(Map data) {
    return TokenInfo._(data['id'], CardInfo._fromBackend(data['card']));
  }

  @override
  String toString() {
    return 'TokenInfo{id: $id, card: $card}';
  }
}
