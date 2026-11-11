import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String address;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.address = '',
  });

  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [id, name, email, role, phone, address];
}