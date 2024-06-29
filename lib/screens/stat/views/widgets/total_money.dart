import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

class TotalMoney extends StatelessWidget {
  // Amount (số tiền) cần hiển thị
  final double text;
  // Id đơn vị tiền tệ
  final String currencyId;
  // Style của text khi trả về
  final TextStyle? textStyle;
  // Dấu giá trị của amount ( '-' khi amount < 0 , '+' khi amount > 0)
  final String digit;
  // Vị trí của text được trả về.
  final TextAlign? textAlign;
  // Biến check xem có xử lý chống tràn hay không (để hiển thị đầy đủ số tiền).
  final bool checkOverflow;

  TotalMoney({
    Key? key,
    required this.text,
    required this.currencyId,
    this.textStyle,
    this.digit = '',
    this.textAlign,
    this.checkOverflow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String finalText = formatText;

    return Text(
      finalText,
      style: textStyle,
      textAlign: textAlign,
    );
  }

  String get formatText {
    Currency defaultCurrency = Currency(code: 'VND', name: 'VND', symbol: 'đ', flag: 'flag', number: 100, decimalDigits: 100, namePlural: 'namePlural', symbolOnLeft: false, decimalSeparator: 'decimalSeparator', thousandsSeparator: 'thousandsSeparator', spaceBetweenAmountAndSymbol: true); // Define your default currency
    Currency currency = CurrencyService().findByCode(currencyId) ?? defaultCurrency;
    //Đơn vị tiền tệ
    String symbol = currency.symbol;
    //Xem xét đơn vị tiền tệ được hiển thị bên trái hay phải amount
    bool onLeft = currency.symbolOnLeft;
    //Dấu của amount ( '-' khi amount < 0 , '+' khi amount > 0)
    String newDigit = this.digit;
    //Giá trị của tiền cần hiển thị
    double newText = this.text;

    //Lấy dấu của amount và lấy giá trị tuyệt đối của amount khi amount < 0;
    if (digit == '' && text < 0) {
      newDigit = text.toString().substring(0, 1);
      newText = double.parse(text.toString().substring(1));
    }


    //Tạo text cần hiển thị
    String finalText;
    if (newText >= 1000000000 && checkOverflow) {
      finalText = onLeft
          ? '~ $newDigit$symbol ${MoneyFormatter(amount: newText).output.compactNonSymbol}'
          : '~ $newDigit${MoneyFormatter(amount: newText).output.compactNonSymbol} $symbol';
    } else {
      finalText = onLeft
          ? '$newDigit$symbol ${MoneyFormatter(amount: newText).output.withoutFractionDigits}'
          : '$newDigit${MoneyFormatter(amount: newText).output.withoutFractionDigits} $symbol';
    }
    return finalText;

  }
}