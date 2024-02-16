import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_estagio/screens/menu_screen.dart';
import 'package:teste_estagio/screens/circle_screen.dart';
import 'package:teste_estagio/screens/triangle_screen.dart';
import 'package:teste_estagio/screens/rectangle_screen.dart';

void main() {
  testWidgets('Integration Test: Navigation from MenuScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MenuScreen()));

    // Verifica se o título "ALADDIN" está presente
    expect(find.text('ALADDIN'), findsOneWidget);

    // Toca no botão para ir para a tela de círculo
    await tester.tap(find.text('Círculo'));
    await tester.pumpAndSettle();

    // Verifica se a tela de círculo está presente
    expect(find.byType(CircleScreen), findsOneWidget);

    // Toca no botão para voltar para o MenuScreen
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Toca no botão para ir para a tela de triângulo
    await tester.tap(find.text('Triângulo'));
    await tester.pumpAndSettle();

    // Verifica se a tela de triângulo está presente
    expect(find.byType(TriangleScreen), findsOneWidget);

    // Toca no botão para voltar para o MenuScreen
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Toca no botão para ir para a tela de retângulo
    await tester.tap(find.text('Retângulo'));
    await tester.pumpAndSettle();

    // Verifica se a tela de retângulo está presente
    expect(find.byType(RectangleScreen), findsOneWidget);
  });
}
