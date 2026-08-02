import '../../../../core/network/api_client.dart';
import '../models/coffee_model.dart';

/// Abstract contract for remote coffee data operations.
abstract class CoffeeRemoteDataSource {
  /// Fetches a list of hot coffee items from the remote API endpoint.
  Future<List<CoffeeModel>> fetchHotCoffees();
}

/// Concrete implementation of [CoffeeRemoteDataSource] using [ApiClient].
class CoffeeRemoteDataSourceImpl implements CoffeeRemoteDataSource {
  final ApiClient apiClient;

  CoffeeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<CoffeeModel>> fetchHotCoffees() async {
    final response = await apiClient.get('/coffee/hot');

    // Pattern match on the Resultex Result object
    return response.fold(
      onSuccess: (value) {
        final List data = value.data;
        return data.map((json) => CoffeeModel.fromJson(json)).toList();
      },
      onFailure: (failure) {
        throw Exception(failure.detailedMessage);
      },
      onLoading: () {
        return [];
      },
    );
  }
}
