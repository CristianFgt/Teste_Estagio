// menu_screen.dart
import 'package:flutter/material.dart';
import 'circle_screen.dart';
import 'rectangle_screen.dart';
import 'triangle_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Escolha o formato do seu tapete'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 180),
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela do Círculo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CircleScreen()),
                );
              },
              child: Text(
                'Círculo',
                style: TextStyle(fontSize: 50),
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(75, 30, 75, 30), // Ajuste os valores conforme necessário
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela do Triângulo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TriangleScreen()),
                );
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
              onPressed: () {
                // Navegar para a tela do Retângulo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RectangleScreen()),
                );
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
    );
  }
}