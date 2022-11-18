double adjustFontSize(String text, [double fontSize = 32]) {
  final bool isLong = text.length > 10;
  final bool isVeryLong = text.length > 15;

  return isLong ? (isVeryLong ? fontSize - 6 : fontSize - 4) : fontSize;
}
