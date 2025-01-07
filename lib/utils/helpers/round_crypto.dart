import 'dart:math';

double roundCrypto(double value, int decimalPlaces) {
  num mod = pow(10.0, decimalPlaces);
  return (value * mod).truncateToDouble() / mod;
}
