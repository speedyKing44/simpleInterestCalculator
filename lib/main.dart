import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.pink[300],
        accentColor: Colors.pink[100]),
    title: "Simple Interest Calculator",
    home: _SimpleCalculator(),
  ));
}

class _SimpleCalculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SimpleCalculatorState();
  }
}

class _SimpleCalculatorState extends State<_SimpleCalculator> {
  var _formKey = GlobalKey<FormState>();
  var _currencies = ["Shillings", "Dollars", "Pound"];
  final _minimumPadding = 5.0;
  var _currentItemSelected;
  var displayText = '';
  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  void initState() {
    _currentItemSelected = _currencies[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(title: Text("Simple Interest Calculator")),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 4),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    style: textStyle,
                    controller: principalController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter principal amount';
                      }
                      
                    },
                    decoration: InputDecoration(
                        labelText: "Principal",
                        labelStyle: textStyle,
                        hintText: "Enter Principal e.g 120",
                        errorStyle: TextStyle(
                            color: Colors.yellowAccent, fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    style: textStyle,
                    controller: roiController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter rate of interest';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Rate of Interest",
                        labelStyle: textStyle,
                        hintText: "In Percent",
                        errorStyle: TextStyle(
                            color: Colors.yellowAccent, fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          controller: termController,
                          style: textStyle,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                           ],
                          validator: (String value)  {
                            if (value.isEmpty) {
                              return 'Please enter time needed';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: "Term",
                              labelStyle: textStyle,
                              hintText: "Time in year",
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                                items: _currencies
                                    .map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(dropDownStringItem),
                                  );
                                }).toList(),
                                value: _currentItemSelected,
                                onChanged: (String newdropDownStringItem) {
                                  _onDropdownItemSelected(
                                      newdropDownStringItem);
                                }))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              "Calculate",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  this.displayText = _calculateTotalReturns();
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Reset",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ),
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Text(
                    displayText,
                    style: textStyle,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _onDropdownItemSelected(String value) {
    setState(() {
      this._currentItemSelected = value;
    });
  }

  Widget getImageAsset() {
    AssetImage assetimage = AssetImage('images/money.png');
    Image image = Image(image: assetimage, width: 125.0, height: 125.0);

    return Container(
        child: image, padding: EdgeInsets.all(_minimumPadding * 10));
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);
    double totalPayable = principal + (principal * roi * term) / 100;

    String result =
        "After $term years, your investment will be worth $totalPayable $_currentItemSelected";

    return result;
  }

  void _reset() {
    principalController.text = " ";
    roiController.text = " ";
    termController.text = " ";
    displayText = " ";
    _currentItemSelected = _currencies[0];
  }
}
