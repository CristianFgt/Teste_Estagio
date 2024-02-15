import 'package:flutter/material.dart';

class CircleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Círculo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Conteúdo da tela do círculo
            Text('Tela do Círculo'),
          ],
        ),
      ),
    );
  }
}
