import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> fetchStatus() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar status da API');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }
}