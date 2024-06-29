import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forex_currency_conversion/forex_currency_conversion.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}
class _CurrencyConverterState extends State<CurrencyConverter> {
  String sourceCurrency = 'USD';
  String lastSourceCurrency = '';
  String destinationCurrency = 'VND';
  String lastDestinationCurrency = '';
  double inputAmount = 0.0;
  double lastInputAmount = 0.0;
  Future<double>? futureRate;
  List<String> currencies = ['USD', 'VND', 'EUR', 'JPY', 'CND', 'BTC'];
  double _currentSliderValue = 0;


  Future<void> convertCurrency() async {
    lastSourceCurrency = sourceCurrency;
    lastDestinationCurrency = destinationCurrency;
    lastInputAmount = inputAmount;
    Forex forex = Forex();
    double rate = await forex.getCurrencyConverted(
      sourceCurrency: sourceCurrency,
      destinationCurrency: destinationCurrency,
    );
    setState(() {
      futureRate = Future.value(inputAmount * rate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              children: [
                const Text(
                  'Exchange Rate Conversion',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Source: ',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 2),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: sourceCurrency,
                                items: currencies.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: DefaultTextStyle(
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic
                                      ), // Set your desired font size here
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    sourceCurrency = newValue!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        const Text(
                          'Destination: ',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 2),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: destinationCurrency,
                                items: currencies.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: DefaultTextStyle(
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic
                                      ), // Set your desired font size here
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    destinationCurrency = newValue!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Tooltip(
                  message: _currentSliderValue.round().toString(),
                  child: Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: 1000,
                    divisions: 1000,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                        inputAmount = value;
                      });
                    },
                  ),
                ),
                OutlinedButton(
                  onPressed: convertCurrency,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    side: const BorderSide(
                        color: Colors.blue), // Border color when button is enabled
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.swap_horiz, // Convert icon
                        color: Colors.white,
                      ),
                      SizedBox(width: 8), // Space between icon and text
                      Text(
                        'Convert',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Text color
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 70),
                if (futureRate != null)
                  FutureBuilder<double>(
                    future: futureRate,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        double rate = snapshot.data!;
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            leading: const Icon(
                              FontAwesomeIcons.moneyBillTransfer,
                              color: Color(0xFF3e9c35),
                            ),
                            title: Text(
                              '$lastInputAmount $lastSourceCurrency is:',
                              style: const TextStyle(
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            trailing: Text(
                              NumberFormat.currency(
                                locale: 'vi_VN',
                                symbol: lastDestinationCurrency,
                              ).format(rate),
                              style: const TextStyle(
                                fontSize: 17,
                                color: Color(0xFF3e9c35),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
          )
      )
    );
  }
}