import 'dart:math';

extension DoubleRounding on double {
  double roundTo(int decimals) {
    final factor = pow(10, decimals);
    return (this * factor).round() / factor;
  }
}
