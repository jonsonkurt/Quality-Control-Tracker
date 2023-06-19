import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

var logger = Logger();

String decodingCred() {
  const String cred = "aojuhU7Kk/FwOMNDr3GBuw==";

  final key = Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final decrypted = encrypter.decrypt(Encrypted.fromBase64(cred), iv: iv);

  return decrypted;
}

encryptPassword(String password) {
  final encryptionKey =
      Key.fromLength(32); // Replace with a valid 256-bit encryption key
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(encryptionKey));

  final encryptedPassword = encrypter.encrypt(password, iv: iv);

  DatabaseReference adminRef = FirebaseDatabase.instance.ref().child("admin");
  adminRef.set({
    "password": encryptedPassword.base64,
  }).then((_) {
    logger.d("Password updated successfully.");
  }).catchError((error) {
    logger.d("Failed to update password: $error");
  });
}

Future<bool> checkPassword(String enteredPassword) async {
  final key = Key.fromLength(32); // Replace with your encryption key
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  DatabaseReference adminRef = FirebaseDatabase.instance.ref().child("admin");

  final snapshot = await adminRef.child('password').get();
  if (snapshot.exists) {
    String encryptedPassword = snapshot.value.toString();
    // String decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);
    String decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

    // String decryptedPassword =
    //     encrypter.decrypt(Encrypted.fromBase64(encryptedPassword), iv: iv);

    return decryptedPassword == enteredPassword;
  } else {
    logger.d('No data available.');
  }

  return false;
}
