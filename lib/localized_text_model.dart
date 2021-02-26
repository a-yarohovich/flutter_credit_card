class LocalizedText {
  const LocalizedText(
      {this.cardNumberLabel = _cardNumberLabelDefault,
      this.cardNumberHint = _cardNumberHintDefault,
      this.cardNumberError = _cardNumberErrDefault,
      this.expiryDateLabel = _expiryDateLabelDefault,
      this.expiryDateHint = _expiryDateHintDefault,
      this.expiryDateErr = _expiryDateErrDefault,
      this.cvvLabel = _cvvLabelDefault,
      this.cvvHint = _cvvHintDefault,
      this.cvvErr = _cvvErrDefault,
      this.cardHolderLabel = _cardHolderLabelDefault,
      this.cardHolderHint = _cardHolderHintDefault,
      this.cardHolderErr = _cardHolderErrDefault});

  static const String _cardNumberLabelDefault = 'Card number';
  static const String _cardNumberHintDefault = 'xxxx xxxx xxxx xxxx';
  static const String _cardNumberErrDefault = 'Invalid card number';
  static const String _expiryDateLabelDefault = 'Expiry Date';
  static const String _expiryDateHintDefault = 'MM/YYYY';
  static const String _expiryDateErrDefault = 'Invalid date';
  static const String _cvvLabelDefault = 'CVV';
  static const String _cvvHintDefault = 'XXX';
  static const String _cvvErrDefault = 'Invalid cvv number';
  static const String _cardHolderLabelDefault = 'Card Holder';
  static const String _cardHolderHintDefault = 'IVAN IVANOV';
  static const String _cardHolderErrDefault = 'Invalid holder name';

  final String cardNumberLabel;
  final String cardNumberHint;
  final String cardNumberError;
  final String expiryDateLabel;
  final String expiryDateHint;
  final String expiryDateErr;
  final String cvvLabel;
  final String cvvHint;
  final String cvvErr;
  final String cardHolderLabel;
  final String cardHolderHint;
  final String cardHolderErr;
}
