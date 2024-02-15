import 'package:flutter/material.dart';
import 'circle_screen.dart';
import 'rectangle_screen.dart';
import 'triangle_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1), // Espaço vazio no topo
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 62),
                        child: Text(
                          'ALADDIN',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 90),
                        ),
                      ),
                      Text(
                        'Escolha o formato do seu tapete',
                        style: TextStyle(fontSize: 26),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await navigateToScreen(context, CircleScreen(), 'circle');
                    },
                    child: Text(
                      'Círculo',
                      style: TextStyle(fontSize: 50),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(75, 20, 75, 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await navigateToScreen(context, TriangleScreen(), 'triangle');
                    },
                    child: Text(
                      'Triângulo',
                      style: TextStyle(fontSize: 50),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(49, 20, 49, 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await navigateToScreen(context, RectangleScreen(), 'rectangle');
                    },
                    child: Text(
                      'Retângulo',
                      style: TextStyle(fontSize: 50),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> navigateToScreen(BuildContext context, Widget screen, String screenType) async {
    switch (screenType) {
      case 'circle':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CircleScreen()),
        );
        break;
      case 'rectangle':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RectangleScreen()),
        );
        break;
      case 'triangle':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TriangleScreen()),
        );
        break;
    }
  }

  Future<void> storeDataLocally(String screenType, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_${screenType}_data', jsonEncode(data));
      print('Dados salvos localmente com sucesso para $screenType: $data');
    } catch (e) {
      print('Erro ao salvar dados localmente para $screenType: $e');
    }
  }

  Future<String?> retrieveDataLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_screen_type');
      if (cachedData != null) {
        return cachedData;
      } else {
        print('Não há dados salvos localmente.');
        return ''; // Retorna uma string vazia em vez de null
      }
    } catch (e) {
      print('Erro ao recuperar dados salvos localmente: $e');
      return ''; // Retorna uma string vazia em caso de erro
    }
  }
}
