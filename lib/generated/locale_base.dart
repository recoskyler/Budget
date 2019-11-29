import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocaleBase {
  Map<String, dynamic> _data;
  String _path;
  Future<void> load(String path) async {
    _path = path;
    final strJson = await rootBundle.loadString(path);
    _data = jsonDecode(strJson);
    initAll();
  }
  
  Map<String, String> getData(String group) {
    return Map<String, String>.from(_data[group]);
  }

  String getPath() => _path;

  Localebuttons _buttons;
  Localebuttons get buttons => _buttons;
  Localedescriptions _descriptions;
  Localedescriptions get descriptions => _descriptions;
  Localehints _hints;
  Localehints get hints => _hints;
  Localemisc _misc;
  Localemisc get misc => _misc;
  Localemonths _months;
  Localemonths get months => _months;
  LocalepaymentDesc _paymentDesc;
  LocalepaymentDesc get paymentDesc => _paymentDesc;
  LocalesubTitles _subTitles;
  LocalesubTitles get subTitles => _subTitles;
  Localetitles _titles;
  Localetitles get titles => _titles;

  void initAll() {
    _buttons = Localebuttons(Map<String, String>.from(_data['buttons']));
    _descriptions = Localedescriptions(Map<String, String>.from(_data['descriptions']));
    _hints = Localehints(Map<String, String>.from(_data['hints']));
    _misc = Localemisc(Map<String, String>.from(_data['misc']));
    _months = Localemonths(Map<String, String>.from(_data['months']));
    _paymentDesc = LocalepaymentDesc(Map<String, String>.from(_data['paymentDesc']));
    _subTitles = LocalesubTitles(Map<String, String>.from(_data['subTitles']));
    _titles = Localetitles(Map<String, String>.from(_data['titles']));
  }
}

class Localebuttons {
  final Map<String, String> _data;
  Localebuttons(this._data);

  String get save => _data["save"];
  String get spend => _data["spend"];
  String get deposit => _data["deposit"];
  String get notPaid => _data["notPaid"];
  String get paid => _data["paid"];
  String get cancel => _data["cancel"];
  String get remove => _data["remove"];
  String get darkTheme => _data["darkTheme"];
  String get lightTheme => _data["lightTheme"];
  String get reset => _data["reset"];
  String get resetSure => _data["resetSure"];
  String get viewGithub => _data["viewGithub"];
  String get self => _data["self"];
  String get budget => _data["budget"];
  String get savings => _data["savings"];
  String get rebel => _data["rebel"];
  String get empire => _data["empire"];
  String get saving => _data["saving"];
  String get contract => _data["contract"];
}
class Localedescriptions {
  final Map<String, String> _data;
  Localedescriptions(this._data);

  String get food => _data["food"];
  String get drink => _data["drink"];
  String get app => _data["app"];
  String get game => _data["game"];
  String get cinema => _data["cinema"];
  String get makeup => _data["makeup"];
  String get clothes => _data["clothes"];
  String get groceries => _data["groceries"];
  String get topUp => _data["topUp"];
  String get tech => _data["tech"];
  String get hobby => _data["hobby"];
  String get travel => _data["travel"];
  String get hotel => _data["hotel"];
  String get hardware => _data["hardware"];
  String get household => _data["household"];
  String get other => _data["other"];
  String get furniture => _data["furniture"];
}
class Localehints {
  final Map<String, String> _data;
  Localehints(this._data);

  String get savingExpenseOverflow => _data["savingExpenseOverflow"];
  String get savingNoBudget => _data["savingNoBudget"];
}
class Localemisc {
  final Map<String, String> _data;
  Localemisc(this._data);

  String get tapRent => _data["tapRent"];
  String get broken => _data["broken"];
}
class Localemonths {
  final Map<String, String> _data;
  Localemonths(this._data);

  String get january => _data["january"];
  String get february => _data["february"];
  String get march => _data["march"];
  String get april => _data["april"];
  String get may => _data["may"];
  String get june => _data["june"];
  String get july => _data["july"];
  String get august => _data["august"];
  String get september => _data["september"];
  String get october => _data["october"];
  String get november => _data["november"];
  String get december => _data["december"];
}
class LocalepaymentDesc {
  final Map<String, String> _data;
  LocalepaymentDesc(this._data);

  String get deposit => _data["deposit"];
  String get expense => _data["expense"];
  String get fixedSaving => _data["fixedSaving"];
  String get rentPayment => _data["rentPayment"];
  String get finRentPayment => _data["finRentPayment"];
  String get utilityPayment => _data["utilityPayment"];
  String get finUtilityPayment => _data["finUtilityPayment"];
  String get subscription => _data["subscription"];
  String get savingDeposit => _data["savingDeposit"];
  String get savingExpense => _data["savingExpense"];
  String get savingToBudget => _data["savingToBudget"];
  String get existingSaving => _data["existingSaving"];
}
class LocalesubTitles {
  final Map<String, String> _data;
  LocalesubTitles(this._data);

  String get transactions => _data["transactions"];
  String get transactionHistory => _data["transactionHistory"];
  String get expenses => _data["expenses"];
  String get savings => _data["savings"];
  String get remaining => _data["remaining"];
  String get day => _data["day"];
  String get amount => _data["amount"];
  String get date => _data["date"];
  String get customDesc => _data["customDesc"];
  String get description => _data["description"];
  String get source => _data["source"];
  String get language => _data["language"];
  String get currency => _data["currency"];
  String get side => _data["side"];
  String get renewalDay => _data["renewalDay"];
  String get allowanceAmount => _data["allowanceAmount"];
  String get budget => _data["budget"];
  String get utilities => _data["utilities"];
  String get rent => _data["rent"];
  String get avgExpenses => _data["avgExpenses"];
  String get avgUtilities => _data["avgUtilities"];
  String get totalSavings => _data["totalSavings"];
  String get duration => _data["duration"];
  String get startingDate => _data["startingDate"];
  String get rentAmount => _data["rentAmount"];
  String get type => _data["type"];
  String get fixedExpenses => _data["fixedExpenses"];
  String get fixedPayments => _data["fixedPayments"];
  String get monthlySavings => _data["monthlySavings"];
  String get today => _data["today"];
}
class Localetitles {
  final Map<String, String> _data;
  Localetitles(this._data);

  String get budget => _data["budget"];
  String get rent => _data["rent"];
  String get fixedPayments => _data["fixedPayments"];
  String get stats => _data["stats"];
  String get settings => _data["settings"];
  String get utilities => _data["utilities"];
  String get spend => _data["spend"];
  String get save => _data["save"];
  String get deposit => _data["deposit"];
  String get addFixed => _data["addFixed"];
  String get setup => _data["setup"];
}
