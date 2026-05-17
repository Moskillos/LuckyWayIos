int amountConverter(String amount) {
  // parsing robusto con due decimali al massimo
  double value = double.parse(amount.replaceAll(',', '.'));
  return (value * 100).round();
}