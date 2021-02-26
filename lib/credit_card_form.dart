import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'credit_card_model.dart';
import 'flutter_credit_card.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
    this.localizedText = const LocalizedText(),
    this.formKey,
  })  : assert(localizedText != null),
        super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;
  final LocalizedText localizedText;
  final GlobalKey<FormState> formKey;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

const _kExpDateMask = '00/0000';
const _kCvvCodeMask = '000';
const _kcardNumberMask = '0000 0000 0000 0000';

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;
  final MaskedTextController _cardNumberController = MaskedTextController(mask: _kcardNumberMask);
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvCodeController = MaskedTextController(mask: _kCvvCodeMask);
  final TextEditingController _cardHolderNameController = TextEditingController();
  final CreditCardExpirationDateFormatter _expDateFormatter =
      CreditCardExpirationDateFormatter(_kExpDateMask);
  void Function(CreditCardModel) onCreditCardModelChange;
  var _formKey = GlobalKey<FormState>();
  static const _kDefaultContainerHeight = 85.0; // Additional size for validation text

  CreditCardModel creditCardModel;
  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel =
        CreditCardModel(cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey;
    createCreditCardModel();
    onCreditCardModelChange = widget.onCreditCardModelChange;
    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              _buildCardNumber(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildExpDate(),
                  ),
                  Expanded(
                    child: _buildCvv(),
                  ),
                ],
              ),
              _buildHolder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardNumber() {
    return Container(
      height: _kDefaultContainerHeight,
      child: TextFormField(
        controller: _cardNumberController,
        cursorColor: widget.cursorColor ?? themeColor,
        style: TextStyle(
          color: widget.textColor,
        ),
        decoration: InputDecoration(
          labelText: widget.localizedText.cardNumberLabel,
          hintText: widget.localizedText.cardNumberHint,
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.length < _kcardNumberMask.length) {
            return widget.localizedText.cardNumberError;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCvv() {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      height: _kDefaultContainerHeight,
      child: TextFormField(
        focusNode: cvvFocusNode,
        controller: _cvvCodeController,
        cursorColor: widget.cursorColor ?? themeColor,
        style: TextStyle(
          color: widget.textColor,
        ),
        decoration: InputDecoration(
          labelText: widget.localizedText.cvvLabel,
          hintText: widget.localizedText.cvvHint,
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        onChanged: (String text) {
          setState(() {
            cvvCode = text;
          });
        },
        validator: (value) {
          if (value.length < _kCvvCodeMask.length) {
            return widget.localizedText.cvvErr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildExpDate() {
    return Container(
      padding: const EdgeInsets.only(right: 8.0),
      height: _kDefaultContainerHeight,
      child: TextFormField(
        controller: _expiryDateController,
        cursorColor: widget.cursorColor ?? themeColor,
        style: TextStyle(
          color: widget.textColor,
        ),
        decoration: InputDecoration(
          labelText: widget.localizedText.expiryDateLabel,
          hintText: widget.localizedText.expiryDateHint,
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [_expDateFormatter],
        validator: (value) {
          if (value.length < _kExpDateMask.length) {
            return widget.localizedText.expiryDateErr;
          }
          return null;
        },
      ),
    );
  }

  Container _buildHolder() {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: TextFormField(
        controller: _cardHolderNameController,
        cursorColor: widget.cursorColor ?? themeColor,
        style: TextStyle(
          color: widget.textColor,
        ),
        decoration: InputDecoration(
          labelText: widget.localizedText.cardHolderLabel,
          hintText: widget.localizedText.cardHolderHint,
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty) {
            return widget.localizedText.cardHolderErr;
          }
          return null;
        },
      ),
    );
  }
}
