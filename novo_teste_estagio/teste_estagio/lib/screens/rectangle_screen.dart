import 'package:flutter/material.dart';

class RectangleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retângulo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Conteúdo da tela do retângulo
            Text('Tela do Retângulo'),
          ],
        ),
      ),
    );
  }
}
