import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData);
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;
  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await client.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await client.post(
      ApiEndpoints.register,
      data: userData,
    );
    return response.data['data'];
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await client.get(ApiEndpoints.me);
    return UserModel.fromJson(response.data['data']['user']);
  }
}