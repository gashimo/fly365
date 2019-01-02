class Flight {
  String _number;
  String _airport;
  String _datetime;
  List<Map<String, String>> _seats;

  Flight(this._number, this._airport, this._datetime, this._seats);

  Flight.map(dynamic obj) {
    this._number = obj['number'];
    this._airport = obj['airport'];
    this._datetime = obj['datetime'];
    this._seats = obj['seats'];
  }

  String get number => _number;
  String get airport => _airport;
  String get datetime => _datetime;
  List get seats => _seats;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_number != null) {
      map['number'] = _number;
    }
    map['airport'] = _airport;
    map['datetime'] = _datetime;
    map['seats'] = _seats;

    return map;
  }

  Flight.fromMap(Map<String, dynamic> map) {
    this._number = map['number'];
    this._airport = map['airport'];
    this._datetime = map['datetime'];
    this._seats = map['seats'];
  }
}