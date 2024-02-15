import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aladdin Tapetes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aladdin Tapetes'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Verificar a conectividade antes de fazer a requisição
            var connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult != ConnectivityResult.none) {
              // Se houver conexão, buscar os dados online
              final data = await fetchData(); // Chamando fetchData
              if (data != null) {
                // Se os dados foram buscados com sucesso, navegar para a próxima tela
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataScreen(data: data)),
                );
              } else {
                // Se ocorreu um erro ao buscar os dados online, tentar buscar os dados armazenados localmente
                final cachedData = await retrieveDataLocally();
                if (cachedData != null) {
                  // Se houver dados armazenados localmente, exibi-los
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DataScreen(data: cachedData)),
                  );
                } else {
                  // Se não houver dados armazenados localmente, exibir uma mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Falha ao buscar dados. Verifique sua conexão com a internet.'),
                  ));
                }
              }
            } else {
              // Se não houver conexão, buscar os dados armazenados localmente
              final cachedData = await retrieveDataLocally();
              if (cachedData != null) {
                // Se houver dados armazenados localmente, exibi-los
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataScreen(data: cachedData)),
                );
              } else {
                // Se não houver dados armazenados localmente, exibir uma mensagem de erro
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Sem conexão com a internet. Não há dados armazenados localmente.'),
                ));
              }
            }
          },
          child: Text('Abrir Tela de Dados'),
        ),
      ),
    );
  }
}

class DataScreen extends StatelessWidget {
  final dynamic data;

  const DataScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados'),
      ),
      body: Center(
        child: Text('Dados: $data'),
      ),
    );
  }
}
Future<void> storeDataLocally(dynamic data) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_menu_data', jsonEncode(data));
  } catch (e) {
    print('Erro ao armazenar dados localmente: $e');
  }
}

Future<dynamic> retrieveDataLocally() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_menu_data');
    return cachedData != null ? jsonDecode(cachedData) : null;
  } catch (e) {
    print('Erro ao recuperar dados armazenados localmente: $e');
    return null;
  }
}
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