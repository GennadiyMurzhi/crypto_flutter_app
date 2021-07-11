import 'dart:collection';

class ProcessingData{
  static Map<String, int> sortedCurrencyPercentValue(
      Map<String, int> currencyPercentValue){

    Map<int, String> invertedPercentKeyValue = Map();
    for(int i = 0; i <= currencyPercentValue.length - 1; i++){
      invertedPercentKeyValue[currencyPercentValue.values.elementAt(i)] =
          currencyPercentValue.keys.elementAt(i);
    }
    SplayTreeMap<int, String> notBeforeSortedValue
    = SplayTreeMap<int, String>.from(invertedPercentKeyValue);

    Map<String, int> sortedValue = Map();
    for(int i = notBeforeSortedValue.length - 1; i >= 0; i--){
      sortedValue[notBeforeSortedValue.values.elementAt(i)] =
          notBeforeSortedValue.keys.elementAt(i);
    }
    return sortedValue;
  }
}