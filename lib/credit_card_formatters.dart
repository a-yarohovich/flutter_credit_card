import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

final RegExp _digitRegex = RegExp(r'[-0-9]+');
final RegExp _digitWithPeriodRegex = RegExp(r'[-0-9]+(\.[0-9]+)?');

String _toNumericString(String inputString, {bool allowPeriod = false}) {
  if (inputString == null) return '';
  var regExp = allowPeriod ? _digitWithPeriodRegex : _digitRegex;
  return inputString.splitMapJoin(regExp, onMatch: (m) => m.group(0), onNonMatch: (nm) => '');
}

bool _isDigit(String character) {
  if (character == null || character.isEmpty || character.length > 1) {
    return false;
  }
  return _digitRegex.stringMatch(character) != null;
}

class CreditCardExpirationDateFormatter extends MaskedInputFormater {
  CreditCardExpirationDateFormatter(this.expDateMask) : super(expDateMask);

  final String expDateMask;

  @override
  String applyMask(String text) {
    var result = super.applyMask(text);
    var numericString = _toNumericString(result);
    String ammendedMonth;
    if (numericString.length > 0) {
      var allDigits = numericString.split('');
      var stringBuffer = StringBuffer();
      var firstDigit = int.parse(allDigits[0]);
      if (firstDigit > 1) {
        stringBuffer.write('0');
        stringBuffer.write(firstDigit);
        ammendedMonth = stringBuffer.toString();
      } else if (firstDigit == 1) {
        if (allDigits.length > 1) {
          stringBuffer.write(firstDigit);
          var secondDigit = int.parse(allDigits[1]);
          if (secondDigit > 2) {
            stringBuffer.write('');
          } else {
            stringBuffer.write(secondDigit);
          }
          ammendedMonth = stringBuffer.toString();
        }
      } else if (firstDigit == 0) {
        if (allDigits.length > 1) {
          stringBuffer.write(firstDigit);
          var secondDigit = int.parse(allDigits[1]);
          if (secondDigit == 0) {
            stringBuffer.write('');
          } else {
            stringBuffer.write(secondDigit);
          }
          ammendedMonth = stringBuffer.toString();
        }
      }
    }
    if (ammendedMonth != null) {
      if (result.length < ammendedMonth.length) {
        result = ammendedMonth;
      } else {
        var sub = result.substring(2, result.length);
        result = '$ammendedMonth$sub';
      }
    }
    return result;
  }
}

class MaskedInputFormater extends TextInputFormatter {
  final String mask;

  final String _anyCharMask = '#';
  final String _onlyDigitMask = '0';
  final RegExp anyCharMatcher;
  String _lastValue;

  /// [mask] is a string that must contain # (hash) and 0 (zero)
  /// as maskable characters. # means any possible character,
  /// 0 means only digits. So if you want to match e.g. a
  /// string like this GGG-FB-897-R5 you need
  /// a mask like this ###-##-000-#0
  /// a mask like ###-### will also match 123-034 but a mask like
  /// 000-000 will only match digits and won't allow a string like Gtt-RBB
  ///
  /// # will match literally any character unless
  /// you supply an [anyCharMatcher] parameter with a RegExp
  /// to constrain its values. e.g. RegExp(r'[a-z]+') will make #
  /// match only lowercase latin characters and everything else will be
  /// ignored
  MaskedInputFormater(this.mask, {this.anyCharMatcher}) : assert(mask != null);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var isErasing = newValue.text.length < oldValue.text.length;
    if (isErasing || _lastValue == newValue.text) {
      return newValue;
    }
    var maskedValue = applyMask(newValue.text);
    var endOffset = max(oldValue.text.length - oldValue.selection.end, 0);
    var selectionEnd = maskedValue.length - endOffset;
    _lastValue = maskedValue;
    return TextEditingValue(
        selection: TextSelection.collapsed(offset: selectionEnd), text: maskedValue);
  }

  bool _isMatchingRestrictor(String character) {
    if (anyCharMatcher == null) {
      return true;
    }
    return anyCharMatcher.stringMatch(character) != null;
  }

  String applyMask(String text) {
    var chars = text.split('');
    var result = <String>[];
    var maxIndex = min(mask.length, chars.length);
    var index = 0;
    for (var i = 0; i < maxIndex; i++) {
      var curChar = chars[index];
      if (curChar == mask[i]) {
        result.add(curChar);
        index++;
        continue;
      }
      if (mask[i] == _anyCharMask) {
        if (_isMatchingRestrictor(curChar)) {
          result.add(curChar);
          index++;
        } else {
          break;
        }
      } else if (mask[i] == _onlyDigitMask) {
        if (_isDigit(curChar)) {
          result.add(curChar);
          index++;
        } else {
          break;
        }
      } else {
        result.add(mask[i]);
        result.add(curChar);
        index++;
        continue;
      }
    }

    return result.join();
  }
}
