import 'package:openpay/openpay.dart';

main(List<String> arguments) async {
  final openpay = Openpay(arguments.first, arguments.last, isSandboxMode: true);

  print(
    await openpay.createToken(
      CardInfo(
        '4111111111111111',
        'Juan Perez Ramirez',
        '21',
        '12',
        '110',
      ),
    ),
  );
}
