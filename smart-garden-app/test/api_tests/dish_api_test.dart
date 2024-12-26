import 'package:flutter_test/flutter_test.dart';
import 'package:smart_garden_app/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dish_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Dish API Tests', () {
    late MockClient client;

    setUp(() {
      client = MockClient();
    });

    test('Fetch dishes', () async {
      // Arrange
      const responseBody = """[{
          "id": "1",
      "name": "draw",
      "description": "Information others record. Certain knowledge month consider check share big maybe.\nProduction per college how. Best cold show oil officer.",
      "original_price": "71.04",
      "discount_price": "7.81",
      "image": null,
      "rating": "4.0",
      "number_of_reviews": 578,
      "category": 782
    }]""";
      when(client.get(Uri.parse('${APIConstant.baseUrl}/food/dish/')))
          .thenAnswer((_) async => http.Response(responseBody, 200));

      // Act
      final response = await client.get(Uri.parse('${APIConstant.baseUrl}/food/dish/'));

      // Assert
      expect(response.statusCode, 200);
      print(response.body);

      expect(response.body, responseBody);
    });

  //   test('Fetch dish detail', () async {
  //     // Arrange
  //     final responseBody = '{"id": "1", "name": "Dish 1", "description": "Description 1", "original_price": 10.0, "discount_price": 8.0, "image": null, "rating": 4.5, "number_of_reviews": 10, "category": "1"}';
  //     when(client.get(Uri.parse('https://api.example.com/dishes/1')))
  //         .thenAnswer((_) async => http.Response(responseBody, 200));
  //
  //     // Act
  //     final response = await client.get(Uri.parse('https://api.example.com/dishes/1'));
  //
  //     // Assert
  //     expect(response.statusCode, 200);
  //     expect(response.body, responseBody);
  //   });
  //
  //   test('Create dish', () async {
  //     // Arrange
  //     final newDish = {
  //       'name': 'Dish 2',
  //       'description': 'Description 2',
  //       'original_price': 12.0,
  //       'discount_price': 10.0,
  //       'image': null,
  //       'rating': 4.0,
  //       'number_of_reviews': 5,
  //       'category': '1'
  //     };
  //     when(client.post(Uri.parse('https://api.example.com/dishes'), body: newDish))
  //         .thenAnswer((_) async => http.Response('{"id": "2"}', 201));
  //
  //     // Act
  //     final response = await client.post(Uri.parse('https://api.example.com/dishes'), body: newDish);
  //
  //     // Assert
  //     expect(response.statusCode, 201);
  //     expect(response.body, '{"id": "2"}');
  //   });
  //
  //   test('Update dish', () async {
  //     // Arrange
  //     final updatedDish = {
  //       'name': 'Updated Dish 1',
  //       'description': 'Updated Description 1',
  //       'original_price': 15.0,
  //       'discount_price': 12.0,
  //       'image': null,
  //       'rating': 4.7,
  //       'number_of_reviews': 15,
  //       'category': '1'
  //     };
  //     when(client.put(Uri.parse('https://api.example.com/dishes/1'), body: updatedDish))
  //         .thenAnswer((_) async => http.Response('{"id": "1"}', 200));
  //
  //     // Act
  //     final response = await client.put(Uri.parse('https://api.example.com/dishes/1'), body: updatedDish);
  //
  //     // Assert
  //     expect(response.statusCode, 200);
  //     expect(response.body, '{"id": "1"}');
  //   });
  //
  //   test('Delete dish', () async {
  //     // Arrange
  //     when(client.delete(Uri.parse('https://api.example.com/dishes/1')))
  //         .thenAnswer((_) async => http.Response('', 204));
  //
  //     // Act
  //     final response = await client.delete(Uri.parse('https://api.example.com/dishes/1'));
  //
  //     // Assert
  //     expect(response.statusCode, 204);
  //     expect(response.body, '');
  //   });
  });
}
