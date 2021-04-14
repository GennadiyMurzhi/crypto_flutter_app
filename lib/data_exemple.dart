import 'dart:math';

class DataExemple {

  static DataExemple _dataExemple = DataExemple();

  static List<double> _dataCurrencyExemple = List(30);

  static List<double> _dataCurrency3m; //3 month 129 600
  static List<double> _dataCurrency1m; //1 month 43 200
  static List<double> _dataCurrency1w; //1 weak 10 080
  static List<double> _dataCurrency2d; //2 day 2880
  static List<double> _dataCurrency24h; //24 hour 1440
  static List<double> _dataCurrency12h; //12 hour 720
  static List<double> _dataCurrency1h; //1 hour 60

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