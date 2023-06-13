import 'package:encrypt/encrypt.dart';

String decodingCred() {
  const String cred = "aojuhU7Kk/FwOMNDr3GBuw==";

  final key = Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final decrypted = encrypter.decrypt(Encrypted.fromBase64(cred), iv: iv);

  return decrypted;
}