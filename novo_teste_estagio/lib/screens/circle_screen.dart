import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CircleScreen extends StatefulWidget {
  @override
  _CircleScreenState createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  double radius = 0.0;
  double pricePerSquareMeter = 0.0;
  bool isPriceCalculated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tapete Redondo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preço por m²: R\$ ${pricePerSquareMeter.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text('Insira o raio do tapete em metros:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  radius = double.tryParse(value) ?? 0.0;
                  isPriceCalculated = false; // Resetar o estado do cálculo
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await calculateAreaAndPrice();
                setState(() {
                  isPriceCalculated = true; // Marcar que o preço foi calculado
                });
              },
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            if (isPriceCalculated)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Área do Tapete: ${calculateArea().toStringAsFixed(2)} m²'),
                  Text('Valor Final: R\$ ${calculatePrice().toStringAsFixed(2)}'),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetValues();
              },
              child: Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }

  double calculateArea() {
    return radius * radius * 3.14159;
  }

  double calculatePrice() {
    return calculateArea() * pricePerSquareMeter;
  }

  Future<void> calculateAreaAndPrice() async {
    try {
      var response = await http.get(Uri.parse('https://testedefensoriapr.pythonanywhere.com/precos'));
      if (response.statusCode == 200) {
        List<dynamic> precos = jsonDecode(response.body);
        var circlePrice = precos.firstWhere((preco) => preco['nome'] == 'Círculo', orElse: () => null);

        if (circlePrice != null) {
          setState(() {
            pricePerSquareMeter = circlePrice['valor_m2'];
          });
          // Salvar os dados localmente após obter os preços da API com sucesso
          await storeDataLocally({'circle_price': pricePerSquareMeter});
        } else {
          print('Preço por m² para o círculo não encontrado na resposta da API.');
        }
      } else {
        print('Falha ao obter preços da API. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao obter preços da API: $e');
      // Se houver erro ao obter os dados online, tentar recuperar os dados salvos localmente
      await retrieveDataLocally();
    }
  }

  void resetValues() {
    setState(() {
      radius = 0.0;
      pricePerSquareMeter = 0.0;
      isPriceCalculated = false; // Resetar o estado do cálculo
    });
  }

  Future<void> storeDataLocally(dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_circle_data', jsonEncode(data));
      print('Dados do círculo salvos localmente com sucesso: $data');
    } catch (e) {
      print('Erro ao salvar dados do círculo localmente: $e');
    }
  }

  Future<void> retrieveDataLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_circle_data');
      if (cachedData != null) {
        final jsonData = jsonDecode(cachedData);
        setState(() {
          pricePerSquareMeter = jsonData['circle_price'];
        });
      } else {
        print('Não há dados do círculo salvos localmente.');
      }
    } catch (e) {
      print('Erro ao recuperar dados do círculo salvos localmente: $e');
    }
  }
}
