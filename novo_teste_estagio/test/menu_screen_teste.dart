import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:teste_estagio/screens/menu_screen.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('MenuScreen', () {
    test('retrieveDataLocally returns cached data if available', () async {
      final sharedPreferences = MockSharedPreferences();
      const menuScreen = MenuScreen();

      // Mockando o comportamento de SharedPreferences
      when(sharedPreferences.getString('cached_screen_type')).thenReturn('cached_data');

      // Simulando a inicialização de SharedPreferences no teste
      SharedPreferences.setMockInitialValues({'cached_screen_type': 'cached_data'});

      // Chamar a função a ser testada
      final result = await menuScreen.retrieveDataLocally();

      // Verificar se o resultado é o esperado
      expect(result, 'cached_data');
    });

    test('retrieveDataLocally returns empty string if no cached data available', () async {
      final sharedPreferences = MockSharedPreferences();
      const menuScreen = MenuScreen();

      // Mockando o comportamento de SharedPreferences
      when(sharedPreferences.getString('cached_screen_type')).thenReturn(null);

      // Simulando a inicialização de SharedPreferences no teste
      SharedPreferences.setMockInitialValues({});

      // Chamar a função a ser testada
      final result = await menuScreen.retrieveDataLocally();

      // Verificar se o resultado é o esperado
      expect(result, '');
    });
  });
}
