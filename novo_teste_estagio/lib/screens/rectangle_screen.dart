import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RectangleScreen extends StatefulWidget {
  @override
  _RectangleScreenState createState() => _RectangleScreenState();
}

class _RectangleScreenState extends State<RectangleScreen> {
  double width = 0.0;
  double length = 0.0;
  double pricePerSquareMeter = 0.0;
  bool isPriceCalculated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tapete Retangular'),
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
            Text('Insira a largura do tapete em metros:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  width = double.tryParse(value) ?? 0.0;
                  isPriceCalculated = false; // Resetar o estado do cálculo
                });
              },
            ),
            SizedBox(height: 20),
            Text('Insira o comprimento do tapete em metros:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  length = double.tryParse(value) ?? 0.0;
                  isPriceCalculated = false; // Resetar o estado do cálculo
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Chamar função para calcular área e preço
                await calculateAreaAndPrice();
                setState(() {
                  isPriceCalculated = true; // Marcar que o preço foi calculado
                });
              },
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            if (isPriceCalculated) // Mostrar o resultado apenas se o preço foi calculado
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
                // Reiniciar o orçamento
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
    return width * length; // Fórmula para a área do retângulo
  }

  double calculatePrice() {
    return calculateArea() * pricePerSquareMeter;
  }

  Future<void> calculateAreaAndPrice() async {
    try {
      var response = await http.get(Uri.parse('https://testedefensoriapr.pythonanywhere.com/precos'));
      if (response.statusCode == 200) {
        List<dynamic> precos = jsonDecode(response.body);
        var rectanglePrice = precos.firstWhere((preco) => preco['nome'] == 'Retângulo', orElse: () => null);

        if (rectanglePrice != null) {
          setState(() {
            pricePerSquareMeter = rectanglePrice['valor_m2'];
          });
          // Salvar os dados localmente após obter os preços da API com sucesso
          await storeDataLocally({'rectangle_price': pricePerSquareMeter});
        } else {
          print('Preço por m² para o retângulo não encontrado na resposta da API.');
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
      width = 0.0;
      length = 0.0;
      pricePerSquareMeter = 0.0;
      isPriceCalculated = false; // Resetar o estado do cálculo
    });
  }

  Future<void> storeDataLocally(dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_rectangle_data', jsonEncode(data));
      print('Dados do retângulo salvos localmente com sucesso: $data');
    } catch (e) {
      print('Erro ao salvar dados do retângulo localmente: $e');
    }
  }

  Future<void> retrieveDataLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_rectangle_data');
      if (cachedData != null) {
        final jsonData = jsonDecode(cachedData);
        setState(() {
          pricePerSquareMeter = jsonData['rectangle_price'];
        });
      } else {
        print('Não há dados do retângulo salvos localmente.');
      }
    } catch (e) {
      print('Erro ao recuperar dados do retângulo salvos localmente: $e');
    }
  }
}
