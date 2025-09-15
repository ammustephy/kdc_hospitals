//
//
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class LoginResult {
//   final String token;
//   LoginResult(this.token);
// }
//
// Future<Map<String, dynamic>> login({required String uid, required String mobile}) async {
//
//   final uri = Uri.parse('http://10.0.2.2:8000/api/auth/login/'); //Emulator
//   // final uri = Uri.parse('http://192.168.243.250:8000/api/auth/login/'); //phone
//   final resp = await http.post(
//     uri,
//     headers: {'Content-Type': 'application/json' , 'Host': '127.0.0.1'},
//     body: jsonEncode({'username': uid, 'password': mobile}),
//   );
//
//     print('Data ${resp.body}');
//
//   if (resp.statusCode == 200) {
//     return jsonDecode(resp.body);
//   } else {
//     throw Exception('Error ${resp.statusCode}: ${resp.body}');
//   }
// }
//
//
//
// // final resp = await http.get(Uri.parse('http://127.0.0.1:8000/api/auth/login/'));


import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> apiLogin(
    {required String uid, required String mobile}) async {
  final uri =
  Uri.parse('http://:8000/api/auth/login/');
  final resp = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username':'admin', 'password': 'Test@1234'}),
  );

  if (resp.statusCode == 200) {
    return jsonDecode(resp.body);
  } else {
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }
}
