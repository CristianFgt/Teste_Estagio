import 'package:flutter/material.dart';

class TriangleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Triângulo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Conteúdo da tela do triângulo
            Text('Tela do Triângulo'),
          ],
        ),
      ),
    );
  }
}
