import 'dart:convert';

void pprint(Map map) {
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(map);
  print(prettyprint);
}
