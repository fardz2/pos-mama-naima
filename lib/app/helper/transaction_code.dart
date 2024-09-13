import 'dart:math';

String generateTransactionCode() {
  const String prefix = 'TX-';
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final Random random = Random();
  String randomString =
      List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  String randomNumber = random.nextInt(1000000).toString().padLeft(6, '0');

  return '$prefix$randomString-$randomNumber';
}
