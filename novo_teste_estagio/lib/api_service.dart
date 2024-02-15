import 'dart:convert';
import 'package:http/http.dart' as http;


Future<dynamic> fetchData() async {
  try {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao buscar dados online: $e');
    return null;
  }
}
