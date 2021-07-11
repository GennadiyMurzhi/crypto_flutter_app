import 'dart:math';

import 'dart:ui';

class DataExemple {

  static DataExemple _dataExemple = DataExemple();

  static List<double> _dataCurrencyExemple = List(30);

  static List<double> _dataCurrency3m;
  static List<double> _dataCurrency1m;
  static List<double> _dataCurrency1w;
  static List<double> _dataCurrency2d;
  static List<double> _dataCurrency24h;
  static List<double> _dataCurrency12h;
  static List<double> _dataCurrency1h;

  static List<String> nameCurrency = [
    "Ripple", "Bitcoin", "Cardano"
  ];

  static Map<String, Color> currencyColor = {
    "Ripple" : Color.fromRGBO(250, 200, 209, 1),
    "Bitcoin" : Color.fromRGBO(121, 140, 205, 1),
    "Cardano" : Color.fromRGBO(126, 201, 213, 1)
  };


  static List<int> exemplePercentValue = List.generate(nameCurrency.length,
          (index) => Random().nextInt(100));

  static Map<String, int> currencyPercentValue = Map.fromIterables(nameCurrency,
      exemplePercentValue);

  static final List<List<double>> dataList = [
    _dataCurrency1h,
    _dataCurrency12h,
    _dataCurrency24h,
    _dataCurrency2d,
    _dataCurrency1w,
    _dataCurrency1m,
    _dataCurrency3m
  ];

  static void createData (){
    for (int i = 0; i < dataList.length; i++)
      dataList[i] = List.generate(30, (index) =>
          Random().nextInt(70).toDouble());
  }

  get data => _dataExemple;

  get dataCurrency => _dataCurrencyExemple;

  //get dataList => _dataList;
}