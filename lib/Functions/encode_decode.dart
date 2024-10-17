String encode(String header, String value) {
  if (header.length != 2) {
    print("Header must be exactly 4 characters long");
  }

  int length = value.length;

  String lengthStr = length.toString().padLeft(2, '0');

  String hlvString = header + lengthStr + value;

  return hlvString;
}
Map<String, dynamic> decodeFromHLV(String hlvString) {
  if (hlvString.length < 4) return {};

  Map<String, String> Headers = {
    '_a': 'Name',
    '_b': 'Last Name',
    '_c': 'Cin',
    '_d': 'Bday',
    '_e': 'Phone',
    '_x': 'Composed'
  };

  Map<String, dynamic> F = {};

  while (hlvString.length >= 4) {
    String header = hlvString.substring(0, 2);
    String? key = Headers[header];

    if (key != null) {
      int length = int.parse(hlvString.substring(2, 4));
      if (header == '_x') {
        String nestedHLV = hlvString.substring(4,4+length);
        Map<String, dynamic> rec = decodeFromHLV(nestedHLV);

        F.addAll({key: rec});
      } else {
        String value = hlvString.substring(4, 4 + length);

        F.addAll({key: value});
      }

      hlvString = hlvString.substring(4 + length);

    } else {
      return F;
    }
  }

  return F;
}


void main() {
  String header = "_a";
  String value = "Youssef";

  String hlvString = encode(header, value);
  //print(hlvString);
  String ch="_e0821897753_a07Youssef_b08Werfelli";
  //print(decodeFromHLV(ch));
  String chx = "_c0822123456_x17_b05Smith_a04John";
  print(decodeFromHLV(chx));


}
