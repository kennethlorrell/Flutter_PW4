import 'dart:math';
import '../utils/constants.dart';

/// --- Розрахунки для вибору кабелю ---
/// Модель результату розрахунку для вибору кабелю
class CableSelectionResult {
  final double requiredCurrentCapacity;
  final double emergencyCurrentCapacity;
  final double crossSectionArea;
  final double thermalStability;

  CableSelectionResult({
    required this.requiredCurrentCapacity,
    required this.emergencyCurrentCapacity,
    required this.crossSectionArea,
    required this.thermalStability,
  });
}

/// Отримуємо економічну густину струму залежно від річного навантаження
double getAluminumCurrentDensity(int usageHours) {
  if (usageHours > 5000) return 1.2;
  if (usageHours >= 3000 && usageHours <= 5000) return 1.4;
  return 1.6;
}

/// Обчислюємо параметри для вибору кабелю
CableSelectionResult calculateCableSelection(
    double nominalVoltage,
    double calculatedLoad,
    double shortCircuitCurrent,
    double shortCircuitDuration,
    int operatingDuration,
    ) {
  double economicCurrentDensity = getAluminumCurrentDensity(operatingDuration);
  double requiredCurrentCapacity = calculatedLoad / (2 * sqrt(3) * nominalVoltage);
  double emergencyCurrentCapacity = requiredCurrentCapacity * 2;
  double crossSectionArea = requiredCurrentCapacity / economicCurrentDensity;
  double thermalStability =
      shortCircuitCurrent * sqrt(shortCircuitDuration) / THERMAL_STABILITY_COEFFICIENT;
  return CableSelectionResult(
    requiredCurrentCapacity: requiredCurrentCapacity,
    emergencyCurrentCapacity: emergencyCurrentCapacity,
    crossSectionArea: crossSectionArea,
    thermalStability: thermalStability,
  );
}

/// --- Розрахунки струму короткого замикання ---
/// Модель результату розрахунку струму короткого замикання
class ShortCircuitCurrentResult {
  final double totalResistance;
  final double shortCircuitCurrent;

  ShortCircuitCurrentResult({
    required this.totalResistance,
    required this.shortCircuitCurrent,
  });
}

/// Розраховуємо струм короткого замикання
ShortCircuitCurrentResult calculateShortCircuitCurrent(
    double nominalVoltage,
    double shortCircuitVoltage,
    double shortCircuitPower,
    double transformerPower,
    ) {
  double xc = (nominalVoltage * nominalVoltage) / shortCircuitPower;
  double xt = (nominalVoltage * nominalVoltage / transformerPower) * (shortCircuitVoltage / 100);
  double totalResistance = xc + xt;
  double shortCircuitCurrent = nominalVoltage / (sqrt(3) * totalResistance);
  return ShortCircuitCurrentResult(
    totalResistance: totalResistance,
    shortCircuitCurrent: shortCircuitCurrent,
  );
}

/// --- Розрахунки для підстанції ---
/// Модель результату розрахунку для підстанції
class SubstationShortCircuitCurrentResult {
  final double Xt;
  final double Xsh;
  final double Zsh;
  final double Xshmin;
  final double Zshmin;
  final double I3;
  final double I2;
  final double I3shmin;
  final double I2shmin;
  final double kpr;
  final double Rshn;
  final double Xshn;
  final double Zshn;
  final double Rshnmin;
  final double Xshnmin;
  final double Zshnmin;
  final double I3shnmin;
  final double I2shnmin;
  final double Rl;
  final double Xl;
  final double Ren;
  final double Xen;
  final double Zen;
  final double Renmin;
  final double Xenmin;
  final double Zenmin;
  final double I3ln;
  final double I2ln;
  final double I3lnmin;
  final double I2lnmin;

  SubstationShortCircuitCurrentResult({
    required this.Xt,
    required this.Xsh,
    required this.Zsh,
    required this.Xshmin,
    required this.Zshmin,
    required this.I3,
    required this.I2,
    required this.I3shmin,
    required this.I2shmin,
    required this.kpr,
    required this.Rshn,
    required this.Xshn,
    required this.Zshn,
    required this.Rshnmin,
    required this.Xshnmin,
    required this.Zshnmin,
    required this.I3shnmin,
    required this.I2shnmin,
    required this.Rl,
    required this.Xl,
    required this.Ren,
    required this.Xen,
    required this.Zen,
    required this.Renmin,
    required this.Xenmin,
    required this.Zenmin,
    required this.I3ln,
    required this.I2ln,
    required this.I3lnmin,
    required this.I2lnmin,
  });
}

/// Розраховуємо параметри підстанції для струму короткого замикання
SubstationShortCircuitCurrentResult calculateSubstationShortCircuitCurrents(
    double Ukmax,
    double Snom,
    double Uvn,
    double Unn,
    double Rcn,
    double Rcmin,
    double Xcn,
    double Xcmin,
    ) {
  double Xt = Ukmax * pow(Uvn, 2) / (Snom * 100);
  double Xsh = Xcn + Xt;
  double Zsh = sqrt(pow(Rcn, 2) + pow(Xsh, 2));
  double Xshmin = Xcmin + Xt;
  double Zshmin = sqrt(pow(Xcmin, 2) + pow(Xshmin, 2));
  double I3 = Uvn * 1000 / (sqrt(3) * Zsh);
  double I2 = I3 * sqrt(3) / 2;
  double I3shmin = Uvn * 1000 / (sqrt(3) * Zshmin);
  double I2shmin = I3shmin * sqrt(3) / 2;
  double kpr = pow(Unn, 2) / pow(Uvn, 2);
  double Rshn = Rcn * kpr;
  double Xshn = Xsh * kpr;
  double Zshn = sqrt(pow(Rshn, 2) + pow(Xshn, 2));
  double Rshnmin = Rcmin * kpr;
  double Xshnmin = Xshmin * kpr;
  double Zshnmin = sqrt(pow(Rshnmin, 2) + pow(Xshnmin, 2));
  double I3shnmin = Unn * 1000 / (sqrt(3) * Zshnmin);
  double I2shnmin = I3shnmin * sqrt(3) / 2;
  double Rl = LINE_LENGTH * LINE_RESISTANCE;
  double Xl = LINE_LENGTH * LINE_REACTANCE;
  double Ren = Rl + Rshn;
  double Xen = Xl + Xshn;
  double Zen = sqrt(pow(Ren, 2) + pow(Xen, 2));
  double Renmin = Rl + Rshnmin;
  double Xenmin = Xl + Xshnmin;
  double Zenmin = sqrt(pow(Renmin, 2) + pow(Xenmin, 2));
  double I3ln = Unn * 1000 / (sqrt(3) * Zen);
  double I2ln = I3ln * sqrt(3) / 2;
  double I3lnmin = Unn * 1000 / (sqrt(3) * Zenmin);
  double I2lnmin = I3lnmin * sqrt(3) / 2;

  return SubstationShortCircuitCurrentResult(
    Xt: Xt,
    Xsh: Xsh,
    Zsh: Zsh,
    Xshmin: Xshmin,
    Zshmin: Zshmin,
    I3: I3,
    I2: I2,
    I3shmin: I3shmin,
    I2shmin: I2shmin,
    kpr: kpr,
    Rshn: Rshn,
    Xshn: Xshn,
    Zshn: Zshn,
    Rshnmin: Rshnmin,
    Xshnmin: Xshnmin,
    Zshnmin: Zshnmin,
    I3shnmin: I3shnmin,
    I2shnmin: I2shnmin,
    Rl: Rl,
    Xl: Xl,
    Ren: Ren,
    Xen: Xen,
    Zen: Zen,
    Renmin: Renmin,
    Xenmin: Xenmin,
    Zenmin: Zenmin,
    I3ln: I3ln,
    I2ln: I2ln,
    I3lnmin: I3lnmin,
    I2lnmin: I2lnmin,
  );
}
