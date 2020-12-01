class CreditCardModel {
  String cardNumber = '';
  String expiryDate = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  CreditCardModel(this.cardNumber, this.expiryDate, this.cvvCode, this.isCvvFocused);
}
