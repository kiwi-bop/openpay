# openpay

Openpay dart package.

Only token creation have been implemented here for now.

## Usage

```
import 'package:openpay/openpay.dart';

main(List<String> arguments) async {
  final openpay = Openpay('MERCHANT_ID', 'API_KEY', isSandboxMode: true);
  final token = await openpay.createToken(
                      CardInfo(
                        '4111111111111111', // card number
                        'Juan Perez Ramirez', // holder name
                        '21', //year
                        '12', //month
                        '110', // cvv
                      ),
                    );
  print(token);
}
``` 

## Getting Started with flutter

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
