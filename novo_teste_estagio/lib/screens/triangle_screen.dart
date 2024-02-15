import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TriangleScreen extends StatefulWidget {
  @override
  _TriangleScreenState createState() => _TriangleScreenState();
}

class _TriangleScreenState extends State<TriangleScreen> {
  double sideLength = 0.0;
  double pricePerSquareMeter = 0.0;
  bool isPriceCalculated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tapete Triangular'),
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
            Text('Insira o comprimento de uma das laterais do tapete triangular em metros:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  sideLength = double.tryParse(value) ?? 0.0;
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
    return (sideLength * sideLength * 0.43301270189); // Fórmula para a área do triângulo equilátero
  }

  double calculatePrice() {
    return calculateArea() * pricePerSquareMeter;
  }

  Future<void> calculateAreaAndPrice() async {
    try {
      var response = await http.get(Uri.parse('https://testedefensoriapr.pythonanywhere.com/precos'));
      if (response.statusCode == 200) {
        List<dynamic> precos = jsonDecode(response.body);
        var trianglePrice = precos.firstWhere((preco) => preco['nome'] == 'Triângulo', orElse: () => null);

        if (trianglePrice != null) {
          setState(() {
            pricePerSquareMeter = trianglePrice['valor_m2'];
          });
          // Salvar os dados localmente após obter os preços da API com sucesso
          await storeDataLocally({'triangle_price': pricePerSquareMeter});
        } else {
          print('Preço por m² para o triângulo não encontrado na resposta da API.');
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
      sideLength = 0.0;
      pricePerSquareMeter = 0.0;
      isPriceCalculated = false; // Resetar o estado do cálculo
    });
  }

  Future<void> storeDataLocally(dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_triangle_data', jsonEncode(data));
      print('Dados do triângulo salvos localmente com sucesso: $data');
    } catch (e) {
      print('Erro ao salvar dados do triângulo localmente: $e');
    }
  }

  Future<void> retrieveDataLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_triangle_data');
      if (cachedData != null) {
        final jsonData = jsonDecode(cachedData);
        setState(() {
          pricePerSquareMeter = jsonData['triangle_price'];
        });
      } else {
        print('Não há dados do triângulo salvos localmente.');
      }
    } catch (e) {
      print('Erro ao recuperar dados do triângulo salvos localmente: $e');
    }
  }
}
